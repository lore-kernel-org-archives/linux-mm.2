Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CBCCAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 00:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE668E0005; Tue,  9 Sep 2025 20:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6988E0001; Tue,  9 Sep 2025 20:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB988E0005; Tue,  9 Sep 2025 20:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFD58E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:54:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5C4F1A0726
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:53:59 +0000 (UTC)
X-FDA: 83871518598.09.8A09D34
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 252ADA000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:53:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J96OMh3/";
	spf=pass (imf15.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757465638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQyP0GZJc1hFrxmU66hajulLthQQnuqIFSCA90Eid9s=;
	b=BU/G4j6n+yI9rJWERgDpXaI4t/vfkR6yz7209vMkwClOIZK5UcLs+yQcLNhWORnVH43ecT
	rWS6CPxWCvFzvk+v1m2X+qFn0NENscHDvJ8+8Yl7qSBNCfC5rdUqhFmaQZtaECmMMbb8gl
	l+ssbkHOqczCcwy89bkCpIQgIVJzZZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757465638; a=rsa-sha256;
	cv=none;
	b=N/Bm9tZUV520eA6b/J34sWR8fpdwmS3CHxILxt0J7UE+AIYWaKxR2qcWf8KfUmFLs1D7YG
	kaExNt1Vwd0QfTI65kFw0BgHyfhTl8NO4eXY1EfZFbgi9a4TWvml/6D2GVOmZZTsAI1PQm
	EqzOO+KMcZBunmd0fTgbS9S2wZyUiR8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J96OMh3/";
	spf=pass (imf15.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77251d7cca6so5276178b3a.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 17:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757465637; x=1758070437; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cQyP0GZJc1hFrxmU66hajulLthQQnuqIFSCA90Eid9s=;
        b=J96OMh3/WMpGfiqKkPdaxZe2f75c0yA6lhOHTWh26JV8JaubSukpBZQXF4Jw/9ZZFP
         ccfnxxEPYG6hU4H6Xi8YHgYjRjMWCgzpwsW4RNGtawQPhnO+WKs4D5cDMP4bLETOQEYu
         UIkgAFpDyiBD1MuKZ7uDf5i38bmOlzbvSRISr8HFn743P3AI9ZlImpU9i2aikyrDdj1A
         Ckw+QzDCQrFlh9W3JUyA/Cf9RM8F/HymVEGlAdFnqWJqiQtw8MHveUVWFPyf3ctk/nw/
         GOQJWzHlaAyED30ykxzAD8/Y0P6DrnMJ020Q8EUZsBMTAsAY19pdb9Xsmcrbk4EoPAh5
         gEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757465637; x=1758070437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQyP0GZJc1hFrxmU66hajulLthQQnuqIFSCA90Eid9s=;
        b=rBnzqYhgccL70c8V/Et1HjDGD8UOoMI9hT6bQFxa7kYroaBWh24ZZGP5MrMoO94dvz
         izoo/uNFObSDqizPf+QDG103Iw4kCN2VjScGL8AZZBoR5/qFlBeF7D/3fLRHJjocVRvG
         V2OtOou6vMi0HIkvecB48+rFNok4LtLaYY4bODL/GGUBwpgyUEgQxx6ypGti/UFHF24J
         fEH3H5/dCDyVTv0F4EhRXPY/QfrR9kDNogXzlHrqUDkhVqI6bSNQkcoiYTmhcZ9QwTdQ
         7cASLFE5XaDSBeYk0P6jtDgJ0s9ZsbnzPLZaYdhciU9kmf53LkTZ/QaOCAVo9uCMT7ym
         B2bA==
X-Forwarded-Encrypted: i=1; AJvYcCUxvEN2JOSfOabpXTvZjB2OnEFnh1Lx8dU4wjIfkswDmPWyxAog7Lo/ZHdA/xkui3k19fpQelaF8Q==@kvack.org
X-Gm-Message-State: AOJu0Ywb1qErT5WSgIHzvezu8S7ZupJaSj0u2d+ymoSWVUCh2yyt1oco
	g1hc0eFVJtnJGGh5+xh/+ifcrMt8ocapbm2XugVWBpti6P/y6DzjOUAR
X-Gm-Gg: ASbGncuyNXvh1pPS83TxSyJ8XETzhqCpSRQffrQOIQPzdBxCnRo8yVnA2gq0m+evyRP
	qzRtbx0aRY8BzaGKxFzEvyMZ64oaHEy0kDjd8pSdBqLpfpqU5DKyHdS0SZxxNMYEmsNrowo/cnO
	2qqcd8dG4a4/RiT4GQwhXGXLc78vd9aDMEuSaaiHZQcDU6sukifxsD/dp9WTNbaeRiipdGmgE86
	vvvCIRUFHkvnJ7uS8aNaKY/R1kXLQPuQaVylgk8QNg2I3RLi1up1Ekqe9bczhq9FvHbIXniDeqY
	q5a72h2f1gvJwqrwhS5UpjPpSdgdoCJOO68Emcy2RMvdoKDV5Ojj0vcgieHUwFBrSAy91uLClq4
	oozR0KG1BiuDJsXRl2J34rscETLBqv8NVUamH
X-Google-Smtp-Source: AGHT+IHAZHC7oAM8pJIFcJFqO6POsM5S1IybN/l0HMvF9MBkuhQT84W6uIqRsAsMv6iq7YsoCXx+4A==
X-Received: by 2002:a05:6a00:2ea8:b0:772:2fad:ff64 with SMTP id d2e1a72fcca58-7742dce028fmr18864649b3a.8.1757465636796;
        Tue, 09 Sep 2025 17:53:56 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662fea7fsm3210232b3a.103.2025.09.09.17.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 17:53:55 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id E65E0420A809; Wed, 10 Sep 2025 07:53:51 +0700 (WIB)
Date: Wed, 10 Sep 2025 07:53:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Andrey Ryabinin <arbn@yandex-team.com>, linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org, Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>, Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 7/7] Documentation, kstate: Add KSTATE documentation
Message-ID: <aMDMHx1spjeETKK4@archie.me>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-8-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250909201446.13138-8-arbn@yandex-team.com>
X-Stat-Signature: 9e6qs797n4n5crywq9e6p9iq4i6q4cez
X-Rspamd-Queue-Id: 252ADA000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757465637-530560
X-HE-Meta: U2FsdGVkX19uNqUArd4g163K3aXgFitsgWuF8KufH50LHveOmCKlcwbosq/FtUI0W3STcXzxIeTX++lbdK/X4Rb4hCoyfOrRf8LxK0NPQFSPpHv68Dyjg1oq9QU48dJbi1KiJCdRx4lX95y6zlWQ+U+24Ly3zAqhqxkCxedtObN3yrF2wPSux7FjhrVIMseDq449jltZRdNXhp/6W+EXIvQcFaf7esWdoxesqXp/Fxd6nK0+qmG3w9mMuhMsitYgyUSr92wo39MsrvQibuOWynGZ9/8F2NkmfXMt6LxPhES1Gx9mabRANQhaKv2VpY7ES4ki9WSN30Qk+NhKNffflgXO6kNNWc3mhLzmEzOk+/5/IoH73+zcnemMxNVmLGUcXfGK5SQLrGlWIYPcA81wUo9lByM9h7I4NjsU2Pm3LqZUx9f/d0p7CvyJTRSvRNdTIpBlNQfJaly56I54+m23/TOjZTdcfDC6DV/wSCbO3k8uAUbTwOPLRPkVkuWLWS20nGd7d9UGqqxL375udzcaj2EBltqv6vWaw4Z38oC7rMOElUWtqcqBo8Q4nTsap8ZDtTFaD6NR5s2wieu2MMw6tBPoAPB8WcafeNhcLJsLvQnf1a36d8yi7xPOX0ALrk/NbbTNDlPuRHb9rFAJjZt/UoJL1oQTgDMppDF5J0zKEOGj4Tqr3z0+uNaYm+2MNZId4ICrVLh576+u1PjnbqqeRbexOB56lR220JHy0cg2doWXhh/jbtyJX5GRx4UnYSgzHdFEwYZvYS8vhILAUDlYN5gXntDI/rYc6fmRLLUQJyGCMXHF+phHu4I5di3KHHRtIeaVzb0aNbNOD2OhAo4KfblLrEVC3p06Wbek3gSIPDqVWhifB3RkBdrDNLl4eBPZwZEczL+88JDF1ZELLsFjRaIEQLqDJW1gt22d9JeiZ2PdMPGsdMYSFzFPtrQdPtGa2T6cMB2QRZlFmHimdf0
 vDbhrKAT
 hviBcMDQZ0B97X5Ha+sZIPXsHebaz28NcEfrXfrfaxD2/QJsLt9GY2vSnaLmvqkd2YO1xceD7szFj44en081l+H1y8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:14:42PM +0200, Andrey Ryabinin wrote:
> +There are _V forms of many KSTATE_ macros to load fields for version dependent fields, e.g.

Escape the trailing underscore (i.e. KSTATE\_).

> +Addition of new field can be done as version dependent field by using _V form of
> +KSTATE_ macro:

Ditto.

> +Subsections
> +-----------
> +Another option is adding subsection to kstate_description. A subsection is
> +additional kstate_description which linked to the main one:
> +
> +struct kstate_description test_state_v2 = {
> +	.name = "test_v2",
> +	.id = KSTATE_TEST_ID_V2,
> +	.fields = (const struct kstate_field[]) {
> +		KSTATE_BASE_TYPE(i, struct kstate_test_data, int),
> +		KSTATE_END_OF_LIST()
> +	},
> +};
> +
> +struct kstate_description test_state = {
> +	......
> +	.subsections = (const struct kstate_description *[]){
> +		&test_state_v2,
> +		NULL
> +	},
> +};

Sphinx errors out on struct snippets like above:

Documentation/core-api/kstate.rst:17: WARNING: Inline emphasis start-string without end-string. [docutils]
Documentation/core-api/kstate.rst:17: WARNING: Inline emphasis start-string without end-string. [docutils]
Documentation/core-api/kstate.rst:21: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
Documentation/core-api/kstate.rst:28: ERROR: Unexpected indentation. [docutils]
Documentation/core-api/kstate.rst:32: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/core-api/kstate.rst:33: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
Documentation/core-api/kstate.rst:84: ERROR: Unexpected indentation. [docutils]
Documentation/core-api/kstate.rst:100: ERROR: Unexpected indentation. [docutils]
Documentation/core-api/kstate.rst:102: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/core-api/kstate.rst:103: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
Documentation/core-api/kstate.rst:106: CRITICAL: Unexpected section title or transition.

...... [docutils]

reStructuredText markup error!

I have to wrap them in literal code blocks:

---- >8 ----
diff --git a/Documentation/core-api/kstate.rst b/Documentation/core-api/kstate.rst
index 981ba162109c34..620d7c126c2038 100644
--- a/Documentation/core-api/kstate.rst
+++ b/Documentation/core-api/kstate.rst
@@ -11,16 +11,16 @@ kstate_description
 ------------------
 
 Most kernel's state is in structs and structs could be described by
-kstate_description. E.g.
+kstate_description. E.g.::
 
-struct kstate_test_data {
+  struct kstate_test_data {
 	int i;
 	unsigned long *p_ulong;
 	char s[10];
 	struct folio *folio;
-};
+  };
 
-struct kstate_description test_state = {
+  struct kstate_description test_state = {
 	.name = "test",
 	.version_id = 1,
 	.id = KSTATE_TEST_ID,
@@ -30,7 +30,7 @@ struct kstate_description test_state = {
 		KSTATE_FOLIO(folio, struct kstate_test_data),
 		KSTATE_END_OF_LIST()
 	},
-};
+  };
 
 Changing data structures
 ------------------------
@@ -55,7 +55,7 @@ There are two version fields:
 
 KSTATE is able to read versions from minimum_version_id to version_id.
 
-There are _V forms of many KSTATE_ macros to load fields for version dependent fields, e.g.
+There are _V forms of many KSTATE_ macros to load fields for version dependent fields, e.g.::
 
 	KSTATE_BASE_TYPE_V(i, struct kstate_test_data, int, 2),
 
@@ -67,7 +67,7 @@ be loaded by any older kernel.
 Removing field
 --------------
 If field is no longer needed it could be marked deprecated using
-KSTATE_*_DEPRECATED macro and bumping ->version_id of kstate_description:
+KSTATE_*_DEPRECATED macro and bumping ->version_id of kstate_description::
 
 	KSTATE_BASE_TYPE_DEPRECATED(k, u16, 1),
 
@@ -80,7 +80,8 @@ Adding new field
 ----------------
 
 Addition of new field can be done as version dependent field by using _V form of
-KSTATE_ macro:
+KSTATE_ macro::
+
 	KSTATE_BASE_TYPE_V(i, struct kstate_test_data, int, 2),
 
 This indicates that 'test_state' only from version 2 and above have field '->i'.
@@ -91,24 +92,24 @@ understand the new V2 'test_state'.
 Subsections
 -----------
 Another option is adding subsection to kstate_description. A subsection is
-additional kstate_description which linked to the main one:
+additional kstate_description which linked to the main one::
 
-struct kstate_description test_state_v2 = {
+  struct kstate_description test_state_v2 = {
 	.name = "test_v2",
 	.id = KSTATE_TEST_ID_V2,
 	.fields = (const struct kstate_field[]) {
 		KSTATE_BASE_TYPE(i, struct kstate_test_data, int),
 		KSTATE_END_OF_LIST()
 	},
-};
+  };
 
-struct kstate_description test_state = {
+  struct kstate_description test_state = {
 	......
 	.subsections = (const struct kstate_description *[]){
 		&test_state_v2,
 		NULL
 	},
-};
+  };
 
 
 Subsection must have a unique ->id. If the receiving side finds a subsection

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

