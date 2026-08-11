Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC0BC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447EA6B009E; Tue, 11 Aug 2026 11:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FA36B009F; Tue, 11 Aug 2026 11:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335396B00A0; Tue, 11 Aug 2026 11:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EABE86B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:25:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78FF3A04D9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:25:03 +0000 (UTC)
X-FDA: 85089361686.25.7BDD8EC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id E1CD51C0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:25:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Uz6B32cm;
	spf=none (imf20.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwk51dDEj/fkdEALdmy31EdKr3gR+zmw9DBa1n5JXPk=;
	b=oLEp3SaHqteqX4J7fxuHb1xbmkghwgmS3RuaCHglLw+qf5zehg82fRcn9IP3sDHRAxdvRz
	b5Xsh4lwdjnlg7udG+sWQeCAxGfDloOnCx/21PsBEtYwlAan94vETl/QuGXVJMOeqOiYTD
	R4IcH14CCFKtOdPhnrsOR08+vCNO3eA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Uz6B32cm;
	spf=none (imf20.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461901;
	b=vUWDZiL3j9WrcdgGaBs6nCc58FsnXJwESpvzoSg5TNb50XZyIJ7XJO3fSaNF1rIoU9RTbe
	MO8IiHMWf5vApsUuKT3cZsl9GGbTfW8oooDCD84GxWFjir5TARGAxt+L4q3FWlQN7JbNYw
	/29Yx24Wa6MlDnADr9r8JZsPQnLR+qo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uwk51dDEj/fkdEALdmy31EdKr3gR+zmw9DBa1n5JXPk=; b=Uz6B32cmMWFrNhgqzkl+/8+BBY
	EyIaRvlvfhdSMyFOL87PvNJ7uZH6qlGOq10XczI+H8ViANSxhYqDquSKEiMhXUJIPRq7cu6ze7AUH
	Uw5FhK2ag/3UbfbwECV0higwmkYv3itd9hd20qCV7RpY8kp/wobnCQZArB6TO9+iY0iu/wGVJ9UpI
	TP1BpzoTCl6JzjyasseiJYqTZK9klJ62Qe2cMH2Q9KoaO9DVa/yHh3htKgv+8f+5sT1tIH1mJ1yf9
	doVwgKff8bpUIF9KJri0rUYNR7D6GQyTHmdVlbgZKUZpjgVxCW8epvOGgvQzj9PdOvE5815btnqJr
	yD5/fLPA==;
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtoLV-00000000c7D-3uDK;
	Tue, 11 Aug 2026 15:24:54 +0000
Message-ID: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand	 <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, 
 =?ISO-8859-1?Q?J=E9r=F4me?= Glisse	 <jglisse@redhat.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 16:24:48 +0100
In-Reply-To: <20260811104229.72fdd928@gandalf.local.home>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
		<20260811135537.GC544626@ziepe.ca>
		<1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
		<20260811142730.GG544626@ziepe.ca>
		<a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
	 <20260811104229.72fdd928@gandalf.local.home>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-TzAbYowBA+Y9KWEI5TGd"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: e8y7ew37jwbngioaoprk7we3hoic438k
X-Rspamd-Queue-Id: E1CD51C0009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786461900-751910
X-HE-Meta: U2FsdGVkX1/3fSiKBCCIh8HkLf6PnHLsIawE/yk/Ltpz5ScxaG4EWLnXNk0t8okD7KmfEVi+jz/1Y+ctvp7SfXj769ExTQNzNe7Yyy27v53scS1s+OZIa8/0FiZ9S7xLcPiyrYoeNaFpl5bGsjHvHviM/+untKg1XEVwol1dl2nFJ/MOf8C/V5x8+k+NejoHu8QmoBYN4NX9BYGzSpOw8+AKMzJsv5rJXceThxdkIZkhS+6Odme60RJOc0lZ0A2YY3l0QxgDXnUwzLlJMLAVtoILG6egvP9uy5OTfZhiGGGCNaZFA7a1kmiLZ47zb7n3dZfZ73jDXJpy7we0zZzSx78AML17e+9W9Uo4S9rZrncOM8WDzAY+CL7vpGO1oLCAywug2IhYgWtF97N07Yulc3vlnbehV+1XWAhCPet/XiPh5qF4kHzhJtXPbEK+mlecW/KNPctCSOdn7AXJ5wr9f8/hpGcOe77QT1zk5EKbVPgNdVcU10ha7gIGMdoFoBmLvqy3QCzvIrkX3UEpyq9Qj1bVhmvJh1mXWpG4DUZ7PpY+SZCXwuSTackZLQRGNK2vNtK1NMnLLEfldJx7YQe28QQgtdSs3bcgIyG6o1jXHZsmbTYSwENbGsNRLvXr51AmEkoZfxRpqJFVBpagZELSUSh4D7gx1qa3SAvBLNpfSslyM7vMOW0GTBcuaWgyobwBmr70fjIy86MxPonZ8oqynFfHtlvWdXZphCmUhuz5Pz6Id5/O+Y/xMcJqaFrSnoy1xzVOV/FovVM96OJvdFuis7p2/lQc8zBxODOxTXBJ9jHez6MEA9aX6o457yYZ2+UEKXfBV9sSDuLg2NTA1R0p3FNfmVeaPNjGQegoLOMB4adKDJBUOUTP3eK9tLpeIFsOycP9p8jX/iyxp1AJGWobJjKVh6re2upHK0VHCMlXVJOvLbXFgVySYQt0veKD7ighAR/OPstUOBYlN2pfwbQ
 noBTp2ej
 wd582Dpwav/CEaYz9xpx3lygjePPdMxX0GXOH0J68ovEAWMkNWEjXLdFJyBskheM4QZ4q5FSO4rEnWhlfRgWmcxUEbZSLB9jRqyDBBDDPJTDIY8sj7InJ0JV/YXWO/SKsbCP4BVxh+lxVmDak7ZZiQMsSfLmEhA7KwfSMUO+ObfURQvUO/b/XZrs4a5e2qyn3W18LuE8FbQ8BELlsWPBBcfy5QWvzg+i45l++snA9mjDI3d+u1UYI8SwfTMg1fFmf84KToJbRpaRLU3IPcogugLNsuRsWeAteaAv5TGPLYnMny46c2k7fVLY7QH58hlJitXNXk6rf5pMVdSOICQ2lfKpcteu0SU7wMGX86DaX7t8FYlJtzO8BopcQI1zNUZsEtB+EOcn/ajWFn8+AqbnUoeDKVo7IGv/l/6JuQTdsjfLXke79KOYW0W8s9PqqBs0UCUXPrnGrz4SEJyCUrVN1PUbkSOUg9umY9yput/2CZaINcXpC2++e7n+kr3oSTNBS/o4i2B7PgnZhB3RZvHOfDDw7AP0+w/VCO1JHZMGUU17EdyS1DrPAc8Nnj7FWr+GmyQfj0eAY57Qa6CUO/9Qed2anavV5NenKiopDoHePcx4x/hPhagsNWq1H1ZmJbyhruVNYgqT5TrPebqK6Z/TpdyhpLXBB44kAnwrNsXZKocXVOqgrGr4JFwrGHdLwputZGk4dQliEbr++GJagRHF8vnxIz2FHqtGij9Xjb+OK2efKmTyrgst7DnKxUoNmIBr64sH+mw5SHx8dZm4nKXOKixO1SoWWRxXfHsmdeaNGUg5cbkTpLkhKTb68nQWC5O4/NFO+7JJPYVTp+53sTK65sBkemUltK5jsdkItmrYkQTVLxdleFbLLjr5QDx86pM885062mv/85H9XFMPWX+R6yDRZIEtV//dBbhOmF8MZ4mLObao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-TzAbYowBA+Y9KWEI5TGd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 10:42 -0400, Steven Rostedt wrote:
> On Tue, 11 Aug 2026 15:33:18 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
>=20
> > > If might_sleep doesn't work sanely at all in preempt_rt then just
> > > globally turn it off?=C2=A0=20
> >=20
> > Turn might_sleep off? Or PREEMPT_RT? :)
> >=20
> > The RT maintainers are on this thread if you want to pick either of
> > those fights... that was not the course of action I chose to take.
>=20
> I guess the question is, what exactly is the reason for sleeping to be
> prohibited? In RT, sleeping is allowed in most context because most conte=
xt
> are threads (like interrupt handlers and such). Now, you still can't slee=
p
> in NMIs and hard interrupt handlers that were not converted to threads, b=
ut
> I'm not sure that's the case here anyway.
>=20
> If the non_block_start() is just a big hammer to make sure things are fin=
e
> in non-RT, it will likely still be fine in RT even though it may block an=
d
> sleep. But what it blocks on are sleeping spin locks that likely would no=
t
> cause an issue here if they didn't cause an issue in non-RT.

That's exactly the case in
https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.camel@=
infradead.org/
which is currently being complained about, but it's actually harmless
and arguably a false positive.

I had a second reason for disabling the overzealous check too: to allow
SRCU grace periods within the notifier callbacks.

> Thus, perhaps something like this:
>=20
> =C2=A0		if (ops->invalidate_range_start) {
> =C2=A0			int _ret;
> =C2=A0
> 			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(ra=
nge))
> 				non_block_start();
> =C2=A0			_ret =3D ops->invalidate_range_start(subscription, range);
> 			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(ra=
nge))
> 				non_block_end();
>=20
> ?

Or put it in a per-mmu-notifier-ops flag (a bit like the one in commit
5ff7091f5a2c, but with almost opposite semantics), and let the drivers
Jason cares about still keep the guard, while KVM doesn't need to. With
or without the RT part...

  static bool mn_enforce_non_block(const struct mmu_notifier_ops *ops,
                                 const struct mmu_notifier_range *range)
  {
        /*=20
         * On PREEMPT_RT even a plain spin_lock() schedules, so the
         * annotation splats on legitimate non-blocking implementations.
         */
        if (IS_ENABLED(CONFIG_PREEMPT_RT))
                return false;
        if (ops->flags & MMU_NOTIFIER_NONBLOCKABLE_MAY_WAIT)
                return false;
        return !mmu_notifier_range_blockable(range);
  }=20

But honestly, I can't see the point in keeping it around at all, given
that I literally had to hack the kernel to make it trigger in the first
place.

--=-TzAbYowBA+Y9KWEI5TGd
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
ZbhwcjIaIxBG7QBtO2p2vaYAAAAAAAA=


--=-TzAbYowBA+Y9KWEI5TGd--

