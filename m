Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA29CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF78F8E0011; Thu,  4 Sep 2025 02:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF878E0002; Thu,  4 Sep 2025 02:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5728E0011; Thu,  4 Sep 2025 02:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD9778E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:46:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62A521DF4A0
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:46:38 +0000 (UTC)
X-FDA: 83850634476.16.F830B77
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA26318000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:46:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PzPr9Zw0;
	spf=pass (imf24.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756968396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=o2eG0cp/psHFj43Kk8cgZo/jfowPJyGr/xhcWREGoSQ=;
	b=SHYIwy0OC3GDPDldFe3wugYos5TQqFgAD3bJlLspwtWU6CvJBXV1+2GV+5R/PL030iMH6y
	f9BQ7JYzwgGdBRkOUopOuPY8CJ97vr5tTpindGOa8OvGkmv2Ub+Za6k2EPTBML1trNsENP
	HTv1JNJh0NLqZLio+zRdSl2eBJkF/M0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756968396; a=rsa-sha256;
	cv=none;
	b=Od38Rjx8/yXA+Xm4d3+KuamI3ySvcuK7fE9shqtwv0DcWNIolG+5I3XOp/MmTP7ADITEaz
	0Xcah6Wb/KmH4oAWIqR7TNNEIFqSTnZojs29r3ZS5htdzWBXnB7onVW53/+SS15DLJDaL/
	aRie+5HMZIVTLGYs2ydhoanrvW3s6sU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PzPr9Zw0;
	spf=pass (imf24.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24b1331cb98so1015355ad.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756968396; x=1757573196; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o2eG0cp/psHFj43Kk8cgZo/jfowPJyGr/xhcWREGoSQ=;
        b=PzPr9Zw0hpkoi8kWP259cpFeYWSBYd8KnbRl1DTJIryb5khsgxEmflr67+EsAHmX1x
         7OLDAjO5fO30fiansugr72I8SsFSYT/2Q1I3C+s64yGxP0vhHuUz5Hzp9yn9yNPpW7O7
         DJEWAHZ1RpGjkQLkTya53GhEU43gr9rjp6SZ14EA5bOAmPr6Le0RaspQGXVFj+cDqbhh
         FBhfprLd/i+UEPUA+T9mO9mTYQSvdkINS1VahQnapzA3MOSysUfXwPUaDFxlYb8zai93
         yg7+k8Q+Xn7SY0fX+3HHlRhT6CqfyX4fsG4qQ652PshOwhmN9a/y5FJR1HFLr52IRa3U
         yt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968396; x=1757573196;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2eG0cp/psHFj43Kk8cgZo/jfowPJyGr/xhcWREGoSQ=;
        b=oTxE7RWusySxAL1wWx17YJm4AzzwiLVXkIppln8AsF/SRcFRKiUBUdMaQ9uU/0gp3s
         8a/7mhu017J9gGfspiGz2ApvbEGFULjmYX/09nzPkSoFcWAAdnFV1I4NNNXj9IwUVWPM
         eQAPZOv9zYsBrdiTnilhdIZwoHuoeyHtOnASAUllQHDB0Et599E2Yx+v5mCkltyGbe+I
         3EnUjusM9yb3b1GQTl9nzzAkDguyuAK3a49rDj+I++qkgQWIeT3EbWszqQlr/00h75c4
         e9mUWI6pzIfepR0KBbqcK/0vmLxGe5DGyxQYu3VNbNHP9vmLSyTR2kY+yH9omvbcJyjw
         vM4A==
X-Gm-Message-State: AOJu0Yyua77rGaShEwGzRU3p8dWT6uyMDvSL5sBDpkXh6OOAfEZYxm94
	jgRZ/JmYxkMAdYuVNqUOMplnagQQWTbXQBXlZ1fqkMry/OXs2qatPvIIcZpRNz07
X-Gm-Gg: ASbGncvU7Lmp6P7rKuqbxTZI0fmIMRaCnSxMx7RiDjP1hotuwKjIENreiC9yLBXXFgg
	AlB8EclppRX/FHtTePj5CqvXilVbcWUm34Ji2b3Rxml0lsf7HpLwB47yBpXuKOELvEqr4/ffq+K
	4pvOCbaNfAJUP9hIV3afHnqSrNJ6DHTvE/uDuYN6cnIlXhjKS7drybhooiOIZ38EcdEeLzXaD0G
	d3ze8n1y8J/eVol41mqEt+S6ib2Ljg+67dMm05iAu0/UhLdds9ZqJkieID64u9ppwPgPvlGeM8W
	DW+/KoOTc7Lvy7IkG/rzSgWePoBXcbybctAGgZXmiUxo1TZ/BS3dLXjsj8IdCQcnG3ALjFqmVjI
	3ppHa6ALW+YOnxER6LMx+r8yeUzTW9g0=
X-Google-Smtp-Source: AGHT+IFclv4NiXp9FbGogUUf1GeeupNytVlkU6Odib54NEEYIdfA6qp3hjHR2VZ9Kz6lEd/nz9L/IQ==
X-Received: by 2002:a17:902:db03:b0:246:e1ff:b223 with SMTP id d9443c01a7336-2491f1393cemr154002715ad.6.1756968395591;
        Wed, 03 Sep 2025 23:46:35 -0700 (PDT)
Received: from hobbes ([2600:70ff:f833:0:8e07:c9e8:902c:6ffa])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cb28c3110sm20635085ad.120.2025.09.03.23.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 23:46:34 -0700 (PDT)
Date: Wed, 3 Sep 2025 20:46:29 -1000
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Kees Cook <kees@kernel.org>, 
	Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH] fork: simplify overcomplicated if conditions
Message-ID: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zoii5ckt5ukh55ig"
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA26318000F
X-Stat-Signature: 9cknepjfw83cpqbbb8hewqgueqwbzjdh
X-Rspam-User: 
X-HE-Tag: 1756968396-992474
X-HE-Meta: U2FsdGVkX1+GZ5GktC7W7E8R66trAEW6IeRrjYiAPysHmn5+HHKHUWq02p4NjF9pDsimWpBeqR786FN6C6SeZp3TrVb2CNHI1PtDvwr3HUQP0YGdxyUOIKtZXwavtxN/PRdTNMnO4m6RiUOsEMTpCeY9R1zXPdQwngm92xDxiVDFbrw7Szh9Z21ACvmqSwDzlx+R7J1L8lECRiJeT8GiMI3xwLfFWxDDs7csQPwr+2GvNNqb3aKtN1IrfzPsEFfAXSLAVYL/QE6j4RFvUNfM5/M4zSjoRkJTcvQqyVUqo4/hjA2w08AVotKkSOUW8DrC0i24rh+gfaK9vudzrwYdxxkQt2JiStFRzyiVUhoPihkQeXZPnRQh1am6REV4g/f37TC9Q8FdrbdcSLXJ4sGgs5xuiM12xZqjrH3hyjxc++zz7G0Hgj21uL0IUXTDCmAu7sL7mHE/OOXYub0LM5MeusL6Ean86jmt42HvId0q7L/ZiXSCPXsZ0FYlaxh1heUhV8K5iDlp++S7Q48S6xsgMcxPndIRvTakN6mud61BHjODNPzA6gnnSuHkVGDyZdP1mKf3wyR95XSBn9YlFDw1LbEFvqdJ6Wpb8t+wNP/VPMQhBQve0rZbHFVJ4REyUlicM5FbMv0ktnfmZgfrqrp6dR3JPE6Z/Lxlt9XAmzDwX0W/OZcTt03e1O6ginm4/ENiPepsgGsEXgHK2Cl6ilm388/kNHSaci/BzUHgN8BrCgUyF+k8K1Vn+4D13Lt6KKZ8iEhkNmx/CvuY3nU/zljetRszzdWN5cwMcXsjgU9+1buJlLUtb6WKj/bCxV6NInwKYUCFwInqyrVcyWMMxgnfej76fBTwsHG69ewefzKuZTxXjsHHteLf+ddWjjUaGTkqxUoJjekiz+30Oo/kxrtQfPus+AyUwVMOATUjS/85Sx5KoBs4f22JV1pHnIgbB3PPwJvZ7/5uPJ0t5Y5vyJt
 oa+YHktZ
 Hqm7Nhbqgngym7a8BuEJ1oDy4LcK+vXp2x/5+45RkTg+P3NK0sKEhAfnaotDV6TNeEsLA/o4WmkYNhzHIN0GT4CoBj4625QZR7LM1dc5YMmwN9i7U570eCzIWLBUn9JoMDLgh9Tx4q5XcBwo+iTVmAEnsqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--zoii5ckt5ukh55ig
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] fork: simplify overcomplicated if conditions
MIME-Version: 1.0

Since `((a & (b|c)) =3D=3D (b|c))` is the same thing as `(a & (b|c))`, use
the second version which is simpler.

Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index af673856499dcaa35e..cb49f25e30e69edaa5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1930,14 +1930,14 @@ __latent_entropy struct task_struct *copy_process(
=20
 	/*
 	 * Don't allow sharing the root directory with processes in a different
 	 * namespace
 	 */
-	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) =3D=3D (CLONE_NEWNS|CLONE_FS))
+	if (clone_flags & (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
=20
-	if ((clone_flags & (CLONE_NEWUSER|CLONE_FS)) =3D=3D (CLONE_NEWUSER|CLONE_=
FS))
+	if (clone_flags & (CLONE_NEWUSER|CLONE_FS))
 		return ERR_PTR(-EINVAL);
=20
 	/*
 	 * Thread groups must share signals as well, and detached threads
 	 * can only be started up within the thread group.
--=20
Cheers,
Joey Pabalinas

--zoii5ckt5ukh55ig
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEx6b1SGGPTKxTmPDYqoHu9CTxowIFAmi5NcUACgkQqoHu9CTx
owLeNw//RtKFfg6M05Wc2B+EejqcACdFpV7ikpBe/Y0ip72QbXbcqF11LwyZeOCs
W7Utk9hFPb6HekYUI3o2xRMbfWjv5+NyiXUE5SBg4U0xQ7klO6oihnBI5SKyX7Wc
BxgR6Qe/+Rx4oEaE3XSBl0bNAIsQMxSQaYDHPuGzmPKsV0UVpqN4VGWdhPt2H4Ro
ap04G4VjU4Bjx+BQrzNYIwrTS4+end3rp2nYalisYFzWdPdPGxXf8Y5arNM81ZRV
1rWaLz2L5PrqHqIQBjfkxoRsCQGW8xWGZWcf9jcN2E5tC56ouAqojIsV5Q1JtGMi
+1zMLSRVRvCR9h1V9BXbUsS2Qu/xZtJfKDOjdyFgThQdAZqFeh956AAW0CxWwyIT
tNn3dJNa1ZEK82MpRDLhuLjSgjFwahYnKJgF+iXUFwp90+OUK3JhPOdewFfOWKto
O3h2z5PqznRddO4cwSUnsBWfjgLHKpN49X2g7ErKLd6m2xtKGh7H6PaotxomE3Bs
NEmBgdev1ID9i1XUGbjq+oAlAaaMMeIhwtbh6cbFotIlxsKtNWbeWLcZsHWzw8in
MDVx81zbCojqUjCp5fL+FyESAVnQbmG9eMBCRUchZrOUfRSpSExl7h4u/XryAQ1/
dE5VhaHbYE22ui/lDNVUGkAGHY/Vkvwz/XhMXH0msVo4amsB9k0=
=+ZzT
-----END PGP SIGNATURE-----

--zoii5ckt5ukh55ig--

