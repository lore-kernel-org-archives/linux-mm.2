Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B16EB1070
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA7C6B00A5; Tue, 10 Mar 2026 11:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1CD6B00A6; Tue, 10 Mar 2026 11:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6096B00A7; Tue, 10 Mar 2026 11:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8E776B00A5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:42:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91A681A012F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:42:07 +0000 (UTC)
X-FDA: 84530569494.20.CEF0AF4
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B2CD1C000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:42:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=WGyUT73F;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773157325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViIdeWt5br4rBsrGxHUMEkJDkD/ERSvSv/UV5SzvttY=;
	b=OWKNpJfyqSZyIcys/701nLq/qG9xoYEYZSroTfL8zX/pRwVzDXX5MGkpW85EYkLNjsvnRk
	3Y6IZ0+ghMjNcVPPEuYNivK0Cy8CF4rMIjq1u4+KFWuFRe88H5hsZXdQLiHKFT+4667t/g
	9sFGwjatGvouD7CK2xWLDrRbeDJqQCA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=WGyUT73F;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773157325; a=rsa-sha256;
	cv=none;
	b=kLaZx8vWTRR+xsACrc7EHPq+YqUZJhX69WhJDszxZMxWJaVeYucjS3YDC0dw9qRcQob4Jn
	WLRzIGduaJ1xGEjRbx7xSfjY2TjO4s7iyfCe5zdTunr5OZt0NCD+oZR9v2ZvR7n4OEw6px
	via7mBjFX79rHqFizWQaPvTxT1trZjA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1773157278; x=1773762078; i=markus.elfring@web.de;
	bh=ViIdeWt5br4rBsrGxHUMEkJDkD/ERSvSv/UV5SzvttY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=WGyUT73FEGUOOobbpfTI5yEU52qIQ6s1WY/i688nStWUQV10XR2CP+ZJ0EI1DoSj
	 Xao+vuSmeqRUvw1rCkfbrx+P2Mp9Xzd85tz+P0j6Nh4ytfn14WxQJkixOYPwoNFGG
	 jx8AZjbjj8u3WdFHou1xq3rWXHkXEWBPl7deq8ZbVbHnVT5Pv4EAbphC6oX0N8H5K
	 AIG7N3YBMhYWhVWaPMrPZLwnZcHqJ3CavL4NESQybJfHoaluRMqMByMA+Rb9kKxzj
	 a9HDg+chG8MVqBskLp97/tiQ7YmHDaT3yXWC/AhQq02RivkCSXoliC76ctKxRSnK4
	 3PX+mH77sQHC3/Cfmg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N5lj7-1vYM6w3zfn-012TrV; Tue, 10
 Mar 2026 16:41:18 +0100
Message-ID: <924acf71-45df-4ea2-9bbd-b6f5ff262b2b@web.de>
Date: Tue, 10 Mar 2026 16:41:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Philipp Hahn <phahn-oss@avm.de>, cocci@inria.fr,
 Julia Lawall <Julia.Lawall@inria.fr>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, dm-devel@lists.linux.dev,
 dri-devel@lists.freedesktop.org, gfs2@lists.linux.dev,
 intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 nicolas.palix@imag.fr, ntfs3@lists.linux.dev,
 samba-technical@lists.samba.org, sched-ext@lists.linux.dev,
 target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
 v9fs@lists.linux.dev
References: <20260310-b4-is_err_or_null-v1-1-bd63b656022d@avm.de>
Subject: Re: [PATCH 01/61] Coccinelle: Prefer IS_ERR_OR_NULL over manual NULL
 check
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-1-bd63b656022d@avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:I49ufsxpBKiFBze+2Qm04f+elx94DZSymOaZcQTAnyd9Dy18WSZ
 l5PlqGBdCeQJnqXYHB7LM8JEThQzWaqt46DhF3JOnbIEKCtwYJeZnzJMAXhMu3h78zedo+b
 2MDr9yfDF5xiOPbOsnoVg9HvEpZouoV7eAA1AasOX+/8mAaWp7eICgl3FZXuUGMMgTPEUmo
 9zEXJmftCILFnPJ5epBUQ==
UI-OutboundReport: notjunk:1;M01:P0:jCe8S3PVhmA=;jIHM+yewjYlED18bQxoGve5P1nn
 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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B2CD1C000C
X-Stat-Signature: 1wt7mj5fhnshh4dtdgzf3wb5ba1sjqyw
X-Rspam-User: 
X-HE-Tag: 1773157325-426329
X-HE-Meta: U2FsdGVkX1/fGT7W4iNw28ET4mPnU8jAc8KxtcYs8Fb5xlBwrh3o03Fmo36GI4Hao6o9y7nzsJCnkW90H4Q76G3uJjesCgf5oDmLTQae6woQycg6VWZINR/DucVKlXzD0RIHZEff+AsX+zZC061CLvpJI9IHnlJ4dyYyxnUPMpJuRNIiDnijU57vw8CSB9OCMevVjgLceeJIkwqoFTwr7GnSagifak8pmzNRILBNp6b48IsKp4bSiN/RIqC8Dq+QquMJTd9onjLzY56Rquz1rt3Sg9K9xg3y2FC1R/Zl8UHdLnrz5ui4SKsm5vC2wWeOaFlOANFbg2EKn3mIWL7m8dvKI2qlMl5evbXAnkSkLgeO48KjiBrhb2nR/BEZZT9BGnzT9tT8EnZqA/fCJejZX/ihNGOeGFaWh1qHFviyxbapOiowHuC/2Pr3TVLj7D0VaOBxiJ6Qo/i85Y9yvF+6rziuYrl72Zc3lTSiNrhSor6wQVw6TzCKPMhgBuRuzAORdWRf+NWY0oqw0vKXXvds+sqMctgZc8uotjpZ0dK0i5az5tR+17leTAxFgtqVrDyv60qQAN+tbuKxd43q3YOWA7bpNtGazgOxZmrFKEtnBVigjQYJOtegkbDOutDJIbNXnYBqWOQbbjK/bctcfFBfeBDTqQSKyzFJKpwvVSwSUVBD2oXEjv5SekVHqwtzRNMe0r071OcCpXxPOyGe+KuJM6IPT5WM88GrSVwEZw1hDd9+FPT5zoksgUDMTYvUKI/wQeeHPkOcETJU9YoE0NEHqqZaXNIC3/6RVpG6T90MhxaVQrWlYqYKdDSPIqOVsT/8grXBHXt1iS2hfJ+1eHzU02gq/E7i5ID5Xg+RmbPQKPBa38JHr0D90G77+l9zTAG2ND6HK3kcC5eSuo9YivPpjI6J8w6HaT2tfpdAMJ7wZRATE7XGTtouRF9+BCF/msoK8cQC1EvtexoSW7SyovF
 Kkii3u5t
 o2S8NPAd8QOS0wxQ1eNQURHuBgiqC4NdpdQC6M5DMD+oYIj0wDV/AYt6fglyfoGg1/s7OnlDyAh2N7kuev53RMIeMUBUD7TOWUhxHzTnykSHpNpzgTCY/8HTzIUlPIaNX5a43M2PGFtwPhEL+WKQFSvng4XnAxi8vS5qD5tlVTN98QE/iHuaSpxftduntNkj069pWemVjFzYlArYbkvaQCY3UtLSOnJmODLM+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Find and convert uses of IS_ERR() plus NULL check to IS_ERR_OR_NULL().
=E2=80=A6

Can this information trigger any more consequences on corresponding summar=
y phrases?


=E2=80=A6
> +++ b/scripts/coccinelle/api/is_err_or_null.cocci
> @@ -0,0 +1,125 @@
=E2=80=A6
> +virtual patch
> +virtual report
> +virtual org

How will interests evolve further for the support of the operation mode =
=E2=80=9Ccontext=E2=80=9D?


> +@p1 depends on patch@
> +expression E;
> +@@
> +(
> +-	E !=3D NULL && !IS_ERR(E)
> ++	!IS_ERR_OR_NULL(E)
> +|
> +-	E =3D=3D NULL || IS_ERR(E)
> ++	IS_ERR_OR_NULL(E)
> +|
> +-	!IS_ERR(E) && E !=3D NULL
> ++	!IS_ERR_OR_NULL(E)
> +|
> +-	IS_ERR(E) || E =3D=3D NULL
> ++	IS_ERR_OR_NULL(E)
> +)

Did you eventually check probabilities for the occurrence of mentioned cas=
e distinctions?


> +@p2 depends on patch@
=E2=80=A6

I suggest to reconsider =E2=80=9Cside effects=E2=80=9D according to the sp=
litting of these SmPL rules
once more.


=E2=80=A6
> +@r2 depends on report || org@
> +identifier I;
> +expression E;
> +position p;
> +@@
> +(
> +*	(I =3D E) !=3D NULL && ... && !IS_ERR@p(I)
> +|
> +*	(I =3D E) =3D=3D NULL || ... || IS_ERR@p(I)
> +)

I doubt that the usage of SmPL asterisks fits to these two operation modes=
.


=E2=80=A6
> +@p5 depends on patch disable unlikely @
> +expression E;
> +@@
> +-\( likely \| unlikely \)(
> +(
> + IS_ERR_OR_NULL(E)
> +|
> + !IS_ERR_OR_NULL(E)
> +)
> +-)

* Would it be nicer to move such SmPL code to the end of the patch rule li=
sting?

* Can this source code search pattern matter also for further operation mo=
des?


Regards,
Markus

