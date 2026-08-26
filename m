Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C121C61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 20:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6026A6B0088; Wed, 26 Aug 2026 16:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3B66B008A; Wed, 26 Aug 2026 16:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8D16B008C; Wed, 26 Aug 2026 16:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 259536B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:31:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC07A1A0240
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:31:15 +0000 (UTC)
X-FDA: 85144565310.04.0AB0E63
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB68AA0009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:31:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=c4kFMpO0;
	spf=none (imf25.hostedemail.com: domain of BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787776274;
	b=FSCsRkbaxUUaXt9xsI8bJuNKaDyVavDOHY3IpSKIBIqWL5lV2GYbIt349cphu9iH4Cwj0t
	uSudKSyXz3v1V9LqbVWpXpn6AkrDZEfKeZxUNzcWpZI6LZeu1NL6a7PxbRSymzq7G01lpp
	irH85OeVGY1rUl2mX2t1lAYVl+FOIsQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=c4kFMpO0;
	spf=none (imf25.hostedemail.com: domain of BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+595d0ee0c1a2dd37ff28+8403+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787776274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBG22HuFcKqOwRZzaBQg3Yl2Pqe1f3bp1oSCi5Wuvuo=;
	b=rf48WYJqzk/697Joxua9k0zGyeeG+V5nkycLvcaqt9W5XZ08E72Rem86sTuiYextciVbvk
	8Wh2c/J4jtVKAD9q6d8AW7lEPFT4xBksXf2s+DoUIAW62ZpDrOKpXPVLMWtMM6KCzXdfAv
	AF75ujU3ceMneo8FmnDyl4KqZaZTEjw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=LBG22HuFcKqOwRZzaBQg3Yl2Pqe1f3bp1oSCi5Wuvuo=; b=c4kFMpO07XdDA3nuabyURhNL4n
	CnmGgGISYBozl+T3Kc+Aluw1/eCEKfqDm8swAtP7ANgxu1NAp4QXcOc8B4lW7TMBnhRzjRxO7+FOD
	r1vGc/uaTNnV3dbvhifA/sugDLwVPT/z20JeLIYUqrYd0gxSV3eHTG84xAomqL1fAtMy9dCTBOmVi
	gYTjOHZxv+8SSoqlQUEtZeB3xTijoDODX3O4DY7b2Fp0Lp6u3ynD3EcrEbO5G5h+kKckJsuSYyBAH
	xzU7uYvIdhz2sbe5+vetodF/3taBUINZCp2zYUrO2GqB/3iU/1s6wpcYeZa5A/H99KsNg63d4GeaP
	ue5Ye/Ew==;
Received: from [167.98.59.108] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wzKGi-000000070A8-33Z7;
	Wed, 26 Aug 2026 20:30:50 +0000
Date: Wed, 26 Aug 2026 21:30:43 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: paulmck@kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Clark Williams <clrkwllms@kernel.org>,
 Simona Vetter <simona.vetter@ffwll.ch>, Jerome Glisse <jglisse@redhat.com>,
 Christian Koenig <christian.koenig@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/mmu=5Fnotifier=3A_Remove_non=5Fb?=
 =?US-ASCII?Q?lock=5Fstart/end=28=29_from_notifier_invocation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <e62a7362-7dd0-4615-8877-6ab675971ab2@paulmck-laptop>
References: <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop> <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org> <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop> <ao3z7Rtw2FROkVpy@google.com> <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop> <20260826073233.T-KtFXmj@linutronix.de> <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org> <dbbd6634-4da9-4ecc-9fb2-d7430e2743ca@paulmck-laptop> <98e123c9-3dc4-45fb-815b-881b3346741c@paulmck-laptop> <ACC45EB6-F881-4EE9-A9F8-D53A2B921FEE@infradead.org> <e62a7362-7dd0-4615-8877-6ab675971ab2@paulmck-laptop>
Message-ID: <06F9A0F0-2177-4173-A201-56325A73F89B@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AB68AA0009
X-Stat-Signature: r5oshttmnmj5r3rwdpnussoiyshb34zf
X-Rspam-User: 
X-HE-Tag: 1787776272-203820
X-HE-Meta: U2FsdGVkX1+Rk2D9JLda5//c59b5QtCYMkGq099ONJy9NmIKYSaGYPMQkZh6PxtcGJsoG3SEwtYDWubOvaKyxmske6AQaZppT2TBhEuu5PwnTBT5brSzNbnKVd2C8WHhrWvrXmwFjzU8g960UHSiGVosl9RRxyKzMQfA5OTy4VyX+lrOneZq4vAJ9ZPsBzDfC0Q/8/osaNpfgg8lWeHnFoh+J9+AJcWVT+GYav6kCyRb0xL4ET3w/sCBDxM+yzuz6wr0YkTtMhyl6OE/q4ciMP9+FgX9U4QWs5zErZ6V97QjUH3fJVmdZLRXMeN1h56ZiPA5EiD6Y1cpSB55IUc2QgHjxj2Uk2mjc0oJZrJ6Hb+ph1tw755yqiO8B4Lpcq8FavWoVeKbVXbBN4r7gpI3IkD5CrDGphpExSQ9WdP1A/PSFKshCE5hHdviSJKnpHmqnhn8nk1RMITDduT9tmKmf++Xf2kV2Kc/OmuDmJuqQYHGnRzRUBD3Q+N7KzHkUMJo1hP/G6FCUF42ZaEuuf4g+mk6SZm5+9qoyCYV076vPhsrhjZayJ+RxVPR2HozpGpBz1/q10VfbEDCRVmdEEdT2vrdoPschsSF4t5FN05rwoP22t3A1ZboBwisZTZYQ/tg/HWhzBOWpaPYlzZG4rMmMusb7AzMuz9H4JwGINf4vs41ffQlq9R7yYYyreiQFtdwpA2aBwFhInxSyoEEdoSqROz9dtNnVmYiDlPYjHS3ZYsdaYNGppE3CeCeuWP4uMHyrd91l18BS2pgskiRDTs3VJyQMlFap1Bv5UoZagLo6gDRkzt77Qyfu3vfwW/zcJEmKa/H556y0XQ1Aw5ELA3v70QGGrEYkBcCC6jT2XlHwNXkZn1MdSbdnWvpdMmSZrOvXiRl6acj+pCKyClKaTdsTe6XFbjZzChZYfslRBEir8NtqbWhQUTxOpAOU4pSVxd9WyzUaYOi+Q8x00b1zu+
 75QaeiA6
 FY5L62bNOBylO4qQ/ejlUbf/Q/CU/O2yU3nsVALA6yk4kcLhyDCiI2t4LrL1g4TRB85BWo4S6XNeofDDSvkSevbjl869tcXl+bPWG4koWM23y2YnHqa7+xyj55xYOBIG2oT0uBYXzwhwr7VX8N4oDzagWF54ftPW11VYT2vY+E0LXe+FxsmLK2mo54LjlLLLdNl4cXZwIv5TIUeDQNDVkDcYgv3SZQc8/vEI3dpklFvU8OXBLeaVsTc7J6Lm25VR2J36PTO4RniC9eJeI8Qfq3p5NpsE91BUfFPILgpozVhrRdoOELCUcO9VhbzrDZj41xiAUw7sdRoq03RIj6QUI4tRio/rjRLvUNGgc4x+H1GbCmG3usdva8lSqms/GCMG2v9G6eOsJEP3sPaqLAmyMUij3VmWWLIQHCY7I9PP/BvNMaELaPC5IpmpeTsI4qXpHOBAS7ZgaSzNaSAHMtHDCGhEVKbqlUCHCX9UiM4fJkIPIp2qJmSbauIcmNiKkriQPmJJz6uvwMr3N3NNOHZD+gk/A+s6XJr97vYZjsLakEJdVb/yyQx5q0bV9kG3y7WBbxdgLtqMglnJxiSDLjR9kmYRGS0yGw246y9KjJSHNpWVk+xLwMPZ4esfb+65vkHlg6SwPVpR68I0lEpCKnbUuWxP1aNM6Ap95WHVABlAmq5n/Sco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 August 2026 20:59:31 BST, "Paul E=2E McKenney" <paulmck@kernel=2Eorg>=
 wrote:
>On Wed, Aug 26, 2026 at 07:01:24PM +0100, David Woodhouse wrote:
>> On 26 August 2026 17:28:27 BST, "Paul E=2E McKenney" <paulmck@kernel=2E=
org> wrote:
>> >On Wed, Aug 26, 2026 at 08:05:06AM -0700, Paul E=2E McKenney wrote:
>> >> On Wed, Aug 26, 2026 at 08:38:27AM +0100, David Woodhouse wrote:
>> >> > On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote=
:
>> >> > > On 2026-08-25 13:51:14 [-0700], Paul E=2E McKenney wrote:
>> >> > > > Very good, preemption disabling it is!=C2=A0 It is quite possi=
ble that the
>> >> > > > PREEMPT_RT guys will need something else, but one thing at a t=
ime=2E
>> >> > >=20
>> >> > > This reminds me of classic RCU ;) It might work in this use case=
 but I
>> >> > > am afraid that other users might come along where it actually hu=
rts=2E
>> >> > > With PREEMPT LAZY the preemption within the read-section should
>> >> > > hopefully be the exception=2E
>> >> >=20
>> >> > Given the way that PREEMPT_RT treats other locks like spinlocks an=
d
>> >> > rwlocks =E2=80=94 turning them into sleeping locks =E2=80=94 I sus=
pect it makes most
>> >> > sense, and is consistent, to also turn rcu_read_lock_atomic() and
>> >> > synchronize_rcu_atomic() into plain rcu_read_lock() and
>> >> > try_synchronize_srcu()+synchronize_scru_expedited()=2E
>> >>=20
>> >> That makes a lot of sense to me=2E
>> >
>> >Another option is to instead fall back to non-atomic SRCU=2E
>>=20
>> That's exactly what I thought I was suggesting; I think I left an 's' o=
ut though :)
>
>Heh!!!
>
>About 20 years ago, I was shocked to learn of a valid use case involving
>sleeping RCU readers, which resulted in SRCU=2E  And now it is time
>to be shocked at non-sleeping sleeping RCU readers, and especially a
>non-sleeping grace-period wait=2E  ;-)
>
>Anyway, easy enough:
>
>#ifdef CONFIG_PREEMPT_RT
>DEFINE_SRCU(whatever);
>#define my_srcu_read_lock() srcu_read_lock(&whatever);
>#define my_srcu_read_unlock(idx) srcu_read_unlock(&whatever, (idx));
>#define my_synchronize_srcu() synchronize_srcu(&whatever);
>#else
>DEFINE_SRCU_ATOMIC(whatever);
>#define my_srcu_read_lock() srcu_read_lock_atomic(&whatever);
>#define my_srcu_read_unlock(idx) srcu_read_unlock_atomic(&whatever, (idx)=
);
>#define my_synchronize_srcu() synchronize_srcu_atomic(&whatever);
>#endif

We could do that for the KVM GPC locking, but more consistent would be to =
change *all* users of the 'atomic' lock under PREEMPT_RT to silently get th=
e sleeping version instead, like PREEMPT_RT does with spinlocks and rwlocks=
=2E

So it's srcu_read_lock_atomic() itself (et al) which would get that if/els=
e treatment=2E



