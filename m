Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CC3F94CBC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16FB16B0088; Tue, 21 Apr 2026 22:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F176B0089; Tue, 21 Apr 2026 22:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29436B008A; Tue, 21 Apr 2026 22:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA8906B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:06:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95BD55EC54
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:06:42 +0000 (UTC)
X-FDA: 84684553044.29.BEAB653
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 931FB140005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:06:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pPhhf51i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shicenci@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776823600; a=rsa-sha256;
	cv=pass;
	b=4yDgdz+GWbQSoS0XyZqS/dOWnAXPJGZBWjaEaWDVh7P0A3IRkmOstMLje+6XO6dNECwZGU
	GdP0hvQhX8dYAbZL0B4Txo1H96oBsZQJB6/74v/m9keBW29urvwpGZ7SgLkp+e/rLhwwBu
	cVHX3xLVcd1ndzmVe3NoEy6aOG24q3s=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pPhhf51i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shicenci@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776823600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90+ZTguyBoHioMQpHwM/C3H2ffo6xO9lKdmYjVtMasw=;
	b=061GE2NiusUumYbNAMR/2oOumCeh51d6m6Y+t2NfjVzpBjbUFqhkHh/Ggqfzv5YeqmaoEr
	KUv+GXpn3pL30wxxTEBnyChLtuL0DxKzUGmKa4usBBhjYzS/6SE0mgY3DHE7snwSmwMubo
	6DLvSUK0G6rRwnbeTvSdyKHjSmoMWOg=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-356337f058aso3149434a91.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776823599; cv=none;
        d=google.com; s=arc-20240605;
        b=a28KMg/msadLIki+rljeZ1tNq4QEEUAkp2qI7ynfBBKfC38RSkZ4Vw9omsRPACFeLu
         wYEWdnRFvyCFNkmTMO61lCG6a23TudbVJkgBDrcdsYONTkrBsn083qqumWX1mSunI32q
         IjKVhZUSbyHIm1LSegz5wqVbIttiMUemJCqHblzXNB+NkWNV3KsTsLCG9yRxLnbSsy93
         TK85T4PHfFGGxAT5v7wberKXp1PbJKlHHseTRAOb0EMWAKm+tCHdVkQJJA4yM2zHDsPE
         OGVate+iWD6g6uKXCzjXDQTzHaTv/XcbNUjgcMjJV4ua0EbnxApc6xmW/xh5BKJMI4CD
         Kcow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=90+ZTguyBoHioMQpHwM/C3H2ffo6xO9lKdmYjVtMasw=;
        fh=p9xiq47HRvEzkA8mZwwVSF2WE2bR6to/05Ex/q6TbYs=;
        b=Qu8LAryznzTs7xQZ806gk2hnVumRXA+LFb/DifgjPGdFnKtnhdQz85DhahqgCoebkh
         H9TomkSTtqQfT9+bWnxZVJmZQIflZ+2UgPkvTajYe2f/3haI5Yhpl0l0qaQ1NqR5BoJM
         DgqgmF833tCmV4cs0MI1Lydb//Y5NF3wfsZ8ypABzVIT7EsOo8GNov6qdokvAOYTNR6i
         iw5aiNcGQeqVbARPyNuFQ7OVIJbaagOl0wYmimWwY/JcSq0xfS4bUlWSBszo8zSnx96p
         IJ+lsCi6w8uLz9tyJfhWeDp5LYAjq8nKHOJCiyckqhp4h36xANe0FlkgEEezqchxyt5r
         NYtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776823599; x=1777428399; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=90+ZTguyBoHioMQpHwM/C3H2ffo6xO9lKdmYjVtMasw=;
        b=pPhhf51iBoNTzKg/ecurHplS44Rav61bwakBotr3BGLC0oyBJoZpDN7lwLciDlWfRB
         90L8JhE9Dpwqh/e5E8JMU7PgxWAh6i4jGbBA5PnaKnSxinwrLAughV8mnBfp3GIfP3D1
         mQYM8QbmndZr9yZsRfgBrmURRjOs7ehWi0loZkB9u2RlzuHPPN/4Xy06qS3aFsniIBhr
         tXzV3IAZTHPPQYSRA1bx7vCcHvSp4ht95NGl0VKHTHvQBjMwWc7WFkaFsqCYJ8b04pie
         niFB7Qr9OXd/uaEuIrEAWVyh2yd8ftvscIKVqE7qIDFYEp7lX1Bzy4G0RS92n8eSQSjG
         ohzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776823599; x=1777428399;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90+ZTguyBoHioMQpHwM/C3H2ffo6xO9lKdmYjVtMasw=;
        b=He/rr0mXk709/lUuxAgd8URpqDG102bAJduako1LqnzIZdCuXfGgQQpx9S93ieeBe7
         G0Xy+lfC9Z+LHt+gNJRWrgH4+Djdt0rgjOdKrbCgssgbdPAl2YtG0V9eK+Izj2AKGfK2
         caxIZy2iL4UDxhxWuTi+YE1n3lCVBYwlR0GpjqDnzFU59m4a8ZGl+aC73lneV6b/VZ2k
         iTyacx0SzesZCN8+iksLjY63dqen3A0aYfUtU3RfvDaqaNDMjdJcmWZ3efhG4m29s/PX
         jc16pEh5BbxznBQWr4b+sv3mFwop/A4VTf6nz3NqBieXvMgBNFP98pT3LyvmEbUluA52
         B54w==
X-Forwarded-Encrypted: i=1; AFNElJ9FWfTxIK/QicImQ5lDMkF0o0M95zHJyYV+gCT6pKjRPPe7WM4R5u+AeboCvITDHZ94ejU4IG6Drw==@kvack.org
X-Gm-Message-State: AOJu0YwTua3IDqx+AFH7fmAAmCxdyGMfkUDc37cV3OdEXo1huqe0YI6Z
	G98Mqu4w7vqdos/SVrzxLRUfN+RVpvr7csLgkkmvTPcEqQE662kKvVqqB7uf3H3CSJW1GtJpLM9
	BFpXXG0ET9DyQF471+zrhz4lDOJ/7BxE=
X-Gm-Gg: AeBDievYRZPO7ObqoVVrhdNKuMyL6Jo+XQFjH3/fS/UPVm1pwrEqI9OStiZmjplgPUO
	UmZzG6VDcNTfHBdw88y6MfqrqpPxUFA+oSUmb95qtcGzCRKjGo07MwITOhjp4WzPzwAJwOPCy8V
	Dt6eGrm8JxR+Il077+OXXT0w+qqWFo4L1BidG4oteDbhW+TXUDhv1tkRh1MjuFJtDDXObvFdfqQ
	orjNN+2S5XSnTTUw1n1VIR0t77Ux433FTifoVvZBfbnRq9Kz82wvvSveQL2kU/DUYcBDIOG9Jvm
	TQX4/Srtkdr1eWX2xYo=
X-Received: by 2002:a17:90b:4a09:b0:35f:b7f5:9cd with SMTP id
 98e67ed59e1d1-36140490614mr19902264a91.20.1776823599178; Tue, 21 Apr 2026
 19:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
 <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org> <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
In-Reply-To: <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
From: Zw Tang <shicenci@gmail.com>
Date: Wed, 22 Apr 2026 10:06:28 +0800
X-Gm-Features: AQROBzB3IdcUoNE8gY4nt8VKhmEXVV5Fnvmw6CBhzLSSLuB-JKuDXfk-zuHB0T8
Message-ID: <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D=3A_=5BBUG=5D_WARNING_in_workingset=5Factivation_trigg?=
	=?UTF-8?Q?ered_by_KVM_page_fault_path_on_Linux_7=2E0=2E0=2D08391=2Dg1d51b370a0?=
	=?UTF-8?Q?f8?=
To: "David Hildenbrand (Arm)" <david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: multipart/alternative; boundary="000000000000752849065002fb4d"
X-Rspamd-Server: rspam10
X-Stat-Signature: qbgt5pjxp6gypb7ykd1j7tqyhoc4j43y
X-Rspam-User: 
X-Rspamd-Queue-Id: 931FB140005
X-HE-Tag: 1776823600-199151
X-HE-Meta: U2FsdGVkX1+7oWUt508GGmKGjmARIowhrfCcg/48mKey8n707DV+D81bMOOfHXWqRleRK2AfGOFm1N31zyQu0sLeLMh1hu61C4i+t4ymWt49Nmgt0za7GWT7/7KzipFwiCvDjHgJuzAM85iJtB58bCIXT6jiDYap/8vKHM5lbh5YKyd1JRiGDUu6UClMVbxIR5GZdnCV5K/4tAw7GMBCMeY57y2KN12SxtA1m4qQ0L3HvNWpMZL7sDEWgz21KWZBMRypgsAf4OnPD8mfJNwwr6QBz3LXXZwQcI48kZloNpkYX+nt8f82c2QZg2u6dyE2aEjqhMhjcs2hhy1wUtPoNNirFulr4RX8S1mxeFRd+MN+vyv0GVcWP3TB94K4phKz3DqXmAJURCc86SnaQytwi/OWj4kg5mLdc/ncQM/m6+thCC1TGhDRgbpuI0hwVNoTzKf+O9/hkZ2DsSDxr9+0XPjBPQDy5t2ki286iExd3go57M9+XkNskUIUxp8KgxU3NN24VQRSN0PSuB2eLfRGVjmR18Dt3D7TUNyhDAAIkxZmFP4sippmkD38h/RtWyweMzJKJyclt9LT1+tR84BL0GtS7l6J0M8QQ9gMBjQH9/sReMTK9IXtbO6p4G/bOYrfZ5zCJ1QKqzhHpcfEtxoP/2sMPelUk8Jh/GZw6+wiJ8Q9Vq/02BbD3zXLHa4G2qUkIVIpQQAbEA5Jw+ofvvQnaWAupT5Zy+xnwZZIVUGhX9r9kqaMrEIvb415LjyNrBoxFW8XTyDJXnJ0HqFuJIsTOG2NCLMdiM5OGjwtrKN1vxmEOELkLn3UEI1OL0q4IalvN00qYdO/yTe4BFshjuDgJf5gmqgdlYfHE1IYrSAHgT4dUJPlM1wFmeS2PzU4UIDXVtMs8AdcRY9to5DpMPBueBRZG0MZ21Rn1GtbHAYOtEyPSaAftOA+1uYZ0lBZMBTh32qZaN9iXF0dt5YtErD
 wX/cGV9f
 k0xBM4Ir0FAFexmaOLfy6HqfnQvijHFKnqHGkBFrFgtFn8FFy+D6/fIJsC1Qth87heZh+O4BYNmm9OItt6Zr5H+6x87rgRVxaWi8C4ppMKZRoXPzYaGb8wKHHHvM3tL7sawxAJh24bd6oPLzk43GkDjDZ5u6d/BtMdO31LXuED0u8vw+sHEo6jLXyGbTL7gwrrK95muyXEcb7qVluTAxLa1uT15d4ioCFEs9aYLzhuHEM1SMpa+cv4ZP5pPWw5fB7tOtrGS0RP3TrXhpbZPyGx4JnlCGE90MEnpeQS0mwaBxGOYPx5X5S48mnn6Q3S4w/Ba4ow8RP5EwLww516xdHM4L7DoG94rCdSdjk7q+ckAV1s8+z2Zrp6iNHNrV22wLM7rKOX9/adq2w8Egoqtyl29k8vQN5xPoynF89GnCwNsQQfnoBZ8MapYNrew34ZJbfTvDjfEDV3SILzzbGk7z9oYfZLCQ6MrFhBmNFetPwtGc9EN+8XT5sU9GjnACFuxF8K+1YjqabkjHA00pe35bzM6lcU+0ZQp9PRE1AcC+iX33bN+BJevgxVSBBKgm7aMQisbUKFyOgdsZpQJ3LUJk9LPnbYIqSyY+WVPO02I1aH6L6E7DFRHipu2PmECQhqlGcr6F+Y+kukF1PKbyBzVfOSMwuPN5RCjNzLgGyZV1Q2YkhwVZ1+cWlLpmZB5mFgCHSwWNh5snpCMxHzMCftilVKpsQ0YfZKN2R6jQnrVOHciizefmKVdb8hYKipzQAkKbu5VwiiecQu+AOl9DtCU9IxzLFi/yfzqrUkn0RUaZtyGhttogwb0IaA4x50uOAicuZxu2GWiLdlKKVQU0JpHsiBYfk6Q9XKIJ1JfeVLj2wgUt8BWWvQOae49IkNeoGeciyo2CW9miB4erDVySxlFJVi9iB/bxvhfoioZVX0VnA+yNChRi6P51Rv1iVEFLgvZgBmr2gc/L6Z6hTs1rbvOyPOift6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000752849065002fb4d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

------------------------------
*=E5=8F=91=E4=BB=B6=E4=BA=BA:* Tang Zw <shicenci@gmail.com>
*=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4:* 2026=E5=B9=B44=E6=9C=8822=E6=97=A5 =
10:03
*=E6=94=B6=E4=BB=B6=E4=BA=BA:* David Hildenbrand (Arm) <david@kernel.org>; =
linux-mm@kvack.org <
linux-mm@kvack.org>; akpm@linux-foundation.org <akpm@linux-foundation.org>;
hannes@cmpxchg.org <hannes@cmpxchg.org>
*=E6=8A=84=E9=80=81:* kvm@vger.kernel.org <kvm@vger.kernel.org>;
linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>;
pbonzini@redhat.com <pbonzini@redhat.com>; seanjc@google.com <
seanjc@google.com>
*=E4=B8=BB=E9=A2=98:* =E5=9B=9E=E5=A4=8D: [BUG] WARNING in workingset_activ=
ation triggered by KVM page
fault path on Linux 7.0.0-08391-g1d51b370a0f8

Hi David,
Thanks for pointing this out.
You are right. The commit id I sent was incorrect. I mistakenly used the
git describe-style suffix g1d51b370a0f8, but the actual git commit is:
1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2
The short commit id is:
1d51b370a0f8
Sorry for the confusion.
I am also re-checking whether the kernel image was built from a clean tree
and whether there were any local modifications when the crash was
reproduced,
so that the reported source line numbers match the exact build.
Thanks.

------------------------------
*=E5=8F=91=E4=BB=B6=E4=BA=BA:* David Hildenbrand (Arm) <david@kernel.org>
*=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4:* 2026=E5=B9=B44=E6=9C=8821=E6=97=A5 =
22:06
*=E6=94=B6=E4=BB=B6=E4=BA=BA:* Zw Tang <shicenci@gmail.com>; linux-mm@kvack=
.org <linux-mm@kvack.org>;
akpm@linux-foundation.org <akpm@linux-foundation.org>; hannes@cmpxchg.org <
hannes@cmpxchg.org>
*=E6=8A=84=E9=80=81:* kvm@vger.kernel.org <kvm@vger.kernel.org>;
linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>;
pbonzini@redhat.com <pbonzini@redhat.com>; seanjc@google.com <
seanjc@google.com>
*=E4=B8=BB=E9=A2=98:* Re: [BUG] WARNING in workingset_activation triggered =
by KVM page
fault path on Linux 7.0.0-08391-g1d51b370a0f8

On 4/21/26 13:17, Zw Tang wrote:
> Hi,
>
> I am reporting a WARNING in workingset_activation() triggered by a
> syzkaller C reproducer on Linux 7.0.0-08391-g1d51b370a0f8.

g1d51b370a0f8 is not a known git commit id.

Do you have an upstream git commit where the line number
include/linux/memcontrol.h:381 makes sense?


--=20
Cheers,

David

--000000000000752849065002fb4d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">



<div>
<div style=3D"font-family:Aptos,Aptos_EmbeddedFont,Aptos_MSFontService,Cali=
bri,Helvetica,sans-serif;font-size:12pt;color:rgb(0,0,0)">
<br>
</div>
<hr style=3D"display:inline-block;width:98%">
<div id=3D"m_7928730215375885432divRplyFwdMsg" dir=3D"ltr"><font face=3D"Ca=
libri, sans-serif" style=3D"font-size:11pt" color=3D"#000000"><b>=E5=8F=91=
=E4=BB=B6=E4=BA=BA:</b> Tang Zw &lt;<a href=3D"mailto:shicenci@gmail.com" t=
arget=3D"_blank">shicenci@gmail.com</a>&gt;<br>
<b>=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4:</b> 2026=E5=B9=B44=E6=9C=8822=E6=
=97=A5 10:03<br>
<b>=E6=94=B6=E4=BB=B6=E4=BA=BA:</b> David Hildenbrand (Arm) &lt;<a href=3D"=
mailto:david@kernel.org" target=3D"_blank">david@kernel.org</a>&gt;; <a hre=
f=3D"mailto:linux-mm@kvack.org" target=3D"_blank">linux-mm@kvack.org</a> &l=
t;<a href=3D"mailto:linux-mm@kvack.org" target=3D"_blank">linux-mm@kvack.or=
g</a>&gt;; <a href=3D"mailto:akpm@linux-foundation.org" target=3D"_blank">a=
kpm@linux-foundation.org</a> &lt;<a href=3D"mailto:akpm@linux-foundation.or=
g" target=3D"_blank">akpm@linux-foundation.org</a>&gt;; <a href=3D"mailto:h=
annes@cmpxchg.org" target=3D"_blank">hannes@cmpxchg.org</a> &lt;<a href=3D"=
mailto:hannes@cmpxchg.org" target=3D"_blank">hannes@cmpxchg.org</a>&gt;<br>
<b>=E6=8A=84=E9=80=81:</b> <a href=3D"mailto:kvm@vger.kernel.org" target=3D=
"_blank">kvm@vger.kernel.org</a> &lt;<a href=3D"mailto:kvm@vger.kernel.org"=
 target=3D"_blank">kvm@vger.kernel.org</a>&gt;; <a href=3D"mailto:linux-ker=
nel@vger.kernel.org" target=3D"_blank">linux-kernel@vger.kernel.org</a> &lt=
;<a href=3D"mailto:linux-kernel@vger.kernel.org" target=3D"_blank">linux-ke=
rnel@vger.kernel.org</a>&gt;; <a href=3D"mailto:pbonzini@redhat.com" target=
=3D"_blank">pbonzini@redhat.com</a> &lt;<a href=3D"mailto:pbonzini@redhat.c=
om" target=3D"_blank">pbonzini@redhat.com</a>&gt;; <a href=3D"mailto:seanjc=
@google.com" target=3D"_blank">seanjc@google.com</a> &lt;<a href=3D"mailto:=
seanjc@google.com" target=3D"_blank">seanjc@google.com</a>&gt;<br>
<b>=E4=B8=BB=E9=A2=98:</b> =E5=9B=9E=E5=A4=8D: [BUG] WARNING in workingset_=
activation triggered by KVM page fault path on Linux 7.0.0-08391-g1d51b370a=
0f8</font>
<div>=C2=A0</div>
</div>

<div dir=3D"ltr">
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
Hi David,</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
Thanks for pointing this out.</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
You are right. The commit id I sent was incorrect. I mistakenly used the<br=
>
<code>git describe</code>-style suffix <code>g1d51b370a0f8</code>, but the =
actual git commit is:</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
The short commit id is:</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
1d51b370a0f8</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
Sorry for the confusion.</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
I am also re-checking whether the kernel image was built from a clean tree<=
br>
and whether there were any local modifications when the crash was reproduce=
d,<br>
so that the reported source line numbers match the exact build.</div>
<div style=3D"margin-top:1em;margin-bottom:1em;font-family:Aptos,Aptos_Embe=
ddedFont,Aptos_MSFontService,Calibri,Helvetica,sans-serif;font-size:12pt;co=
lor:rgb(0,0,0)">
Thanks.</div>
<div style=3D"font-family:Aptos,Aptos_EmbeddedFont,Aptos_MSFontService,Cali=
bri,Helvetica,sans-serif;font-size:12pt;color:rgb(0,0,0)">
<br>
</div>
<div id=3D"m_7928730215375885432x_appendonsend"></div>
<hr style=3D"display:inline-block;width:98%">
<div id=3D"m_7928730215375885432x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"=
Calibri, sans-serif" color=3D"#000000" style=3D"font-size:11pt"><b>=E5=8F=
=91=E4=BB=B6=E4=BA=BA:</b> David Hildenbrand (Arm) &lt;<a href=3D"mailto:da=
vid@kernel.org" target=3D"_blank">david@kernel.org</a>&gt;<br>
<b>=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4:</b> 2026=E5=B9=B44=E6=9C=8821=E6=
=97=A5 22:06<br>
<b>=E6=94=B6=E4=BB=B6=E4=BA=BA:</b> Zw Tang &lt;<a href=3D"mailto:shicenci@=
gmail.com" target=3D"_blank">shicenci@gmail.com</a>&gt;; <a href=3D"mailto:=
linux-mm@kvack.org" target=3D"_blank">linux-mm@kvack.org</a> &lt;<a href=3D=
"mailto:linux-mm@kvack.org" target=3D"_blank">linux-mm@kvack.org</a>&gt;; <=
a href=3D"mailto:akpm@linux-foundation.org" target=3D"_blank">akpm@linux-fo=
undation.org</a> &lt;<a href=3D"mailto:akpm@linux-foundation.org" target=3D=
"_blank">akpm@linux-foundation.org</a>&gt;; <a href=3D"mailto:hannes@cmpxch=
g.org" target=3D"_blank">hannes@cmpxchg.org</a> &lt;<a href=3D"mailto:hanne=
s@cmpxchg.org" target=3D"_blank">hannes@cmpxchg.org</a>&gt;<br>
<b>=E6=8A=84=E9=80=81:</b> <a href=3D"mailto:kvm@vger.kernel.org" target=3D=
"_blank">kvm@vger.kernel.org</a> &lt;<a href=3D"mailto:kvm@vger.kernel.org"=
 target=3D"_blank">kvm@vger.kernel.org</a>&gt;; <a href=3D"mailto:linux-ker=
nel@vger.kernel.org" target=3D"_blank">linux-kernel@vger.kernel.org</a> &lt=
;<a href=3D"mailto:linux-kernel@vger.kernel.org" target=3D"_blank">linux-ke=
rnel@vger.kernel.org</a>&gt;; <a href=3D"mailto:pbonzini@redhat.com" target=
=3D"_blank">pbonzini@redhat.com</a> &lt;<a href=3D"mailto:pbonzini@redhat.c=
om" target=3D"_blank">pbonzini@redhat.com</a>&gt;; <a href=3D"mailto:seanjc=
@google.com" target=3D"_blank">seanjc@google.com</a> &lt;<a href=3D"mailto:=
seanjc@google.com" target=3D"_blank">seanjc@google.com</a>&gt;<br>
<b>=E4=B8=BB=E9=A2=98:</b> Re: [BUG] WARNING in workingset_activation trigg=
ered by KVM page fault path on Linux 7.0.0-08391-g1d51b370a0f8</font>
<div>=C2=A0</div>
</div>
<div><font size=3D"2"><span style=3D"font-size:11pt">
<div>On 4/21/26 13:17, Zw Tang wrote:<br>
&gt; Hi,<br>
&gt; <br>
&gt; I am reporting a WARNING in workingset_activation() triggered by a<br>
&gt; syzkaller C reproducer on Linux 7.0.0-08391-g1d51b370a0f8.<br>
<br>
g1d51b370a0f8 is not a known git commit id.<br>
<br>
Do you have an upstream git commit where the line number<br>
include/linux/memcontrol.h:381 makes sense?<br>
<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</div>
</span></font></div>
</div>
</div>

</div>

--000000000000752849065002fb4d--

