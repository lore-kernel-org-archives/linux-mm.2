Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2407CD8C8E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 17:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636196B0088; Sat,  6 Jun 2026 13:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E70F6B008A; Sat,  6 Jun 2026 13:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6306B008C; Sat,  6 Jun 2026 13:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6DE6B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 13:44:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDCBB1C1F34
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 17:44:23 +0000 (UTC)
X-FDA: 84850212006.11.3374999
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id E95E8140007
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 17:44:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AcbncteF;
	spf=pass (imf26.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780767862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8/jaItJY7WDpAzUWHVQcS+f43pWTZf1MJey3/FU7xc=;
	b=v+Na9x41aXyYZVCmjiCyJpq+kZ0ZP4cUlsjXPhmP6uhyYvq1o/Ouj0J6SIxQbTXKy3XUwE
	xCVs6Kx50ZS5GJ04Gly7J/QruCerMMCLEJJaNt3zoTHFzVbitoxQ3HOrrjsGtd6LWYIP+6
	CHOMOBw7jnCpangUhqXkDBWxRmCBe0w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780767862;
	b=A69xiBFDCvw0uYW3P/k9bg9vS6QeFb4/YC3fS0wrujh4SvydOyb/iWtbR5+gpddDEVTkWa
	czKEYBkQzy5XbTfePfYyA2Gv3NYI7olqrMYL0Ai7ScwWJA69rwh84zN+0QgMp1OImPJBm3
	gfr/PswcNQwLNLCyqApoFJhEGmRokSc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AcbncteF;
	spf=pass (imf26.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490be29c1c5so36721355e9.2
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 10:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780767860; x=1781372660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8/jaItJY7WDpAzUWHVQcS+f43pWTZf1MJey3/FU7xc=;
        b=AcbncteFF/VtvjrmBiH5uYCl0BX8lqO0i2DXFhGj0Vm5VtEnTIyGyTnZD3XMohtuW2
         kj5lKzw7ykj0vG/NYL+9boB2nFGnT+8IhXXMIi8WbFiwlAalW9pbFD06SfscePFV3+q0
         YGW4wMXNoZRE/q0fP9seIGClW01jdOVti1SqVj/LUdn9ko9a5Okg448oliYsJIbZfqMn
         8uid8/FbHD2zqM5C+vs/Sy3Zn7YUxL4tKwomfhJDleS0Qc7I9PKSxdcueOco0riduhZ1
         wtu+yPkVI6O4p2Ks7FEy2YUbuhhjrLEBpQW0R7m7s6V/eUB5M4mkvvCpgHWsgzoK2apO
         97Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780767860; x=1781372660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y8/jaItJY7WDpAzUWHVQcS+f43pWTZf1MJey3/FU7xc=;
        b=d8mtStLGgNpa3Drd8wZuiXqPM6eTLpfAMaUzchrdaAsenkZQaWe68KJyT7KJx24qqP
         vcUEc9XJnxF4ma8u+7OHVY8hENWploUwas4zhlkRJnuvftYlv8rT+GXf0Ocr+FRCWYxs
         PeGI8eYNAaXsvJrZOWZnYyrHlzxDxVCr0QcnwZRDtCLjcdXvaRphkv1FL8gzBYhJzNqi
         lvDFJYbjkVYWLVNzMEeU+iBRTq2Hhp3uWMXueV8IhbvHtYHVugh3PIPA6Veu0nieCf0/
         zeLLIOAoCq54boOz/qiLKbJQhNYZ9fGWZYlvKY8XJPtwMDQ01ad31VOnRv9l2In/a7ZM
         oS1g==
X-Forwarded-Encrypted: i=1; AFNElJ8Ch3lNiLscp2nigr2tJ1vgJU67rRmGUTpxMkxksM8ynbF42gyeUMvBaCGwSi2OzyvVpCLK5PvnUg==@kvack.org
X-Gm-Message-State: AOJu0YyY+RctBED4zMTaGES9t1xbvXEU8xsyJlRfYGVm2HNJIF2OYaR4
	+WiynuKmqqEQGjsYTI3fFUIEhHTp+SuaZ5FO5BQiHA0/f3MXKy7ssYE=
X-Gm-Gg: Acq92OH7NSRL+mTAbDKRSx0/Cv8q7AcWxVjLnBjux9KmWlTd557SFyzrx3PK0IrjLag
	8JJ76oJFyIbOovhvWzGLnAgN6Iz2ggfQ5qRdqRIrSAMjtaeC7WhSFvRb9hWU8nWeDsv7HvT1A6Y
	JQ1XlfanRhncAbuBXllroGxR4yeyy96ABRpiJufLIaDgUrviWVDzwfmh/n6nGr4h6eH5WsWePtu
	6SEmEqHThwl9pX0yBV5ypNMTn8p9vSrgpphVkdi6me8g/UW8GWN3EyAemE5GEa8oyOHjN22/LoW
	9bpTm+tlwmbe19hA73EK30OvJFqx3Lv3HiLUw7FhVM0DeupbjKRTkDNkcQRxfDOFt5YvQ53/8aH
	R8+55kwFIThaZjCWIvKrSNCtBI0WvxSOyJ53TKB8iBgHAGr19yJ9nVZ4fEFJCveSWXwfZ5XinU8
	1rL9rk0CsaGV3SDQxQ8xSsVkaJ+mTUEm9uQ/pCSz8SSs9G1GWa8h7atPvrEGSVlv4OWLeturMXD
	SsjGWiMQgJGiIabaokRZfPjmMHudP3PFgu2Tz3AFg==
X-Received: by 2002:a05:600c:524a:b0:490:b11f:2560 with SMTP id 5b1f17b1804b1-490c256f131mr157979935e9.9.1780767860114;
        Sat, 06 Jun 2026 10:44:20 -0700 (PDT)
Received: from hp-ubuntu.. ([41.248.186.206])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d5d2b4sm127326035e9.2.2026.06.06.10.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 10:44:19 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: document slab cache isolation with SLAB_NO_MERGE
Date: Sat,  6 Jun 2026 18:44:12 +0100
Message-ID: <20260606174412.4843-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <874ijfvec2.fsf@trenco.lwn.net>
References: <20260606155856.15548-1-med08elkadiri@gmail.com> <874ijfvec2.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E95E8140007
X-Rspam-User: 
X-Stat-Signature: 55usqrourxgrf361d784b5sr9cwyg9sf
X-Rspamd-Server: rspam08
X-HE-Tag: 1780767861-801790
X-HE-Meta: U2FsdGVkX1+Qp7HeOD/PXlFVMKzzVRpdXDqY3CuvpX4WHgsCakvLeLd2Gr+rrsYMHIbc0IhgRf38e698drjnuPEJ1HsSV+nr9s/q+k62b6Pmt7YlqO4XaDeQypWE/s/AOaf5/n4G+yuRiT+fzVLOhfGQvHZkNnRgT/ZQoSMuRhY+RYkYrlT/FbZjkOep9ZjzZDED7hjAj0fwjDm9WG/utVpyyTDBE8Tc/5dOvJ4U/5c6Uw6MvXB+UXWarmWBDc+QBuA+3Jc/pe5N0YcLsr4baVn1p5DQ1Xgtkqn2+ChkRnTo/UgwPf4M3Qgs6FGm6lqQhO7PPR3/Wla5vFU1+XFkPV3uPYCdLmTqdCNT/P1vtM8zy5RoeHOERX9VQxsjnE2mRtCyLRsgMBlqYoG+/pSRDa+HLui8oR3Jr4U2lwFhK74dnAHS4orLPp6Cf2EL6h2zTKv/8b6hRiZjY9ik3InXSrKY3KnbQpVw2/oBWMuUjIqOhRUY3Fyz8/dCVuI7/IgF4lgPbITECWsmOhILWwN64msHgHOhW2zLfxPPnmSj5ASUDMWoqlHJFUMl+h+njOTivSBwsjYodVoHyORWz81o7dN5xyoMKzVKQ5gsHErDQGWHP44ZINq0xL27zzr4j/RqRoapFUFBZU4PnYGJ2AGbHu5nXhS6Mws4uHqrX8/fKjIk33ZGBsnctcqcRZpDU0o1uM80rahiS+dpSCqOu6A2E3tExQI9KDT+fo3qK4IHoLUe9nOl8GqkCuQFJqCrQDA7LBLfDXf8nCMVXaquysM6/ZfqbIw0MEmdO1hUXahr02PQwyBoBLI4Kd7EZxtPFmpXfA6NpPfaNQKgyJCkk0JigG9lfnXwOxBwlKhujq0IhkVX9wXQwPGWZWnuDbfrScM4qpR/T0caoB+mK6th2XjrLNJInOVyZKfgn84qMIH3QV1B1EJV7OR0GzLiYddCHCZTmS7Xa+2ArdkKoh+jKOU
 woSvAUsp
 H0j4G7KFPyQuv6RiR+ZtViAoUozbYURIuDWRv3slkOjZgKMot8gi9ElOTLUh0FgLfe19ARJv1Mh6ncwrLb0VG1hlcyUoY38YBMcQ+5p6PgXSzoU3GtR51Q1zrOnTNPElH8iXbW8IKKtxUodiFjHspYLvW6vYAoMGD0n8pZdU60ZsmsHTHwGEy/xh4+d5KDiW5heFpFK7wkA/yfKdtAMdJIVmXZ5hFXRAeSH7BrRi1rsuM8Zk5POK4qTjfBR2kCg6lof/hB0Tnocw+L7QFpicT4ugWDIKIM3cXpFPJGWdLcurPjDkaLqI8m885uDavZvjkKH0IysIanEyxsrwtNgp5KgfZnPLA37Mhk7JIOCxRZaJacI3bXdcrtgHtrKHK/eRBe3HM6eSTvTT48pwPxi0lEnNLfmLeEI/Q3NsfVNg/DD9PIWVOYFW4rEz4FS/J3ZGIt3i8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jonathan,

Thank you for the review.

Yes, I used AI assistance in writing this document. The technical
content reflects my understanding from working on the SLAB_NO_MERGE
patches (one of which was Acked by Vlastimil Babka), but I failed to
follow the documentation markup conventions.

I will fix the markup and resubmit as v2.

Mohammed

