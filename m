Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B22606B391
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JmxYWQTA
Received: by kanga.kvack.org (Postfix)
	id 41A176B00EF; Wed,  4 Nov 2026 17:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0FE6B05B0; Wed,  4 Nov 2026 17:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307266B05B1; Wed,  4 Nov 2026 17:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F53E6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EB471C429F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:30:34 +0000 (UTC)
X-FDA: 85398881988.22.37BA21B
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id AA86B40009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:30:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JmxYWQTA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45IHMvHuNfQHmQp3e/l7ZQyBPSv/bWU1s+/SnIhe5+k=;
	b=HiUPo8erUXfXErCqFyvEPqRR2IsqvcFd92trrYg8SgH7G9PMkm6sv1VF7bmqKsF7bXdTWk
	EBpmqr/lijD/dCPNBpdoclddeEs8/Ml8naz5QbgR1/MuXdAvWDU8XqWIfj6FQtE1PpcQmF
	smX9Y16BX0Fuwd29Tz3gyI5t9PvHlhs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831432;
	b=7ma0CJk2LhBd3dygc1uea6/sfG22PERj8ZxbmeFYko8VH3gs+wpY1bPTemeTxnKQK7tnRv
	hJ8aLud9heiMAh6dTfnWL5UhqGwbg7vubPJn9pcd/o9Dq5hlVxm3zT09dbwoNLpMzZx969
	nKCGzXKUN/VBWzPRJeG5wVfV3sBsBEk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JmxYWQTA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd6a7b62ce8so538418a12.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793831431; x=1794436231; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=45IHMvHuNfQHmQp3e/l7ZQyBPSv/bWU1s+/SnIhe5+k=;
        b=JmxYWQTAV41qbJzeX+s/k7NdjXYfBB74vhPZ6ENLllpD8umuKh/II6AlcoUrY1+h+5
         eDV6hQ7ZvzPvPniuitpmWVilZU5uv5b7cWuVNi89HntD+H3Hz0bngxAG7OnJjk3esT9C
         Oj8GOcp6zRrj4zwu3wb5HWCwi3rvlfCk+3kRSlJIfqIXSfjHzLNkQMax3ceS18sVViGS
         pSwdpnBvlYht6vt5h+guEQyju7UL2BD6x1y4EAc7XC9EmFCEWxvYFJQAt+0GcnPr8gB7
         SDK6W/x6Xu0jXqeKB/Pnk3IuOKqg35iAdmAp3160j66PeeppITNHXB9HIAkUCYQIn+zi
         0j/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793831431; x=1794436231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=45IHMvHuNfQHmQp3e/l7ZQyBPSv/bWU1s+/SnIhe5+k=;
        b=M5/G42BYHxD/hA74zmkRWda/JFZGkZoWEVnpr7TmCSCenff9wsFxNEliTlwasCppTs
         h7v2iny9HKm534GEXDvwDz4imJw64tW/T7i45h9Cl+DOQzjrPFhe2xCB0d9OL5o31F7u
         tTmE70Ng3VqW1GNG9nwvISOODXqndTrwcKs5Vt6CliRxLUZTY7OT0ZTeHPF2/D6wDmNh
         WVoUxgcsgnbRQY76+PSobdDYcRzVY9oR+cqfPRoidMPmsJ1AHBhSS2F8Oh/odCxX5EO/
         v2p0pnxNVdrPBxjrDGUytF+rsl3Qky2d7DymqfH4uVNbby9bnPDHwccD1OtL6iAz2A0R
         AAaw==
X-Forwarded-Encrypted: i=1; AKwUvBws4slzIhPwZlihigadaUf2v9u3w3Dp0mLUZLKq0B2aaMAZ00/J8rD13h0keCgEm4WKV627UgRlDg==@kvack.org
X-Gm-Message-State: APuU4Z+kBYGJOUmHF4F+snCuZIY0iENfatJ6LqzFgP3ZdwTsY5EFOIpm
	sJoynJ3Z4s9KMt14MYHlXAFshVU4vFwZgSTGteeuB6ngvLT5YC4Cbdi8CQU2eZ8T4DfseyEQEnf
	kz7YyqQJ6
X-Gm-Gg: AYBFou0tbWIP1pXMDHANt4s/GdOID1tASG+h3TTECnONEoceBy67bj1e5CzHI578t65
	6CyBdWmAX1hszFLJL/JmVRGXGnBQPeNZUz07bErdpJGPaUq9p+mZFJfl63VBgfoqr521oVk7+Ez
	d3Ryva1jdqbGuhqpdGuILuqxMquVWAhYWT0WGTxsggZ0xE5PHLx8KkYTzfkheOamwZ3Ei9XJTQt
	C53yxcnF00nI29xrmp6Aa4id5+v7JLFNDC4KvK2WiGAhVnS+1p6rx3qoDgfoVHY0bjk2f15A4hJ
	SyarV0lWWL1BxwAyI2t0auHWmWdtX+pwMHyJk8HPVGltUshK+pfOEy0wkugFUwyKyMbqxXFgUxs
	Tz+hOkEvc+yDy9eoUvlFZxsJ0ZwN3218akCcJu+GUpGkLOEOy1ACwHh1at4erYVyPbwR2MHVQ22
	3zlAjlq1J83Dy5Uzo/K7gsOZl2KrPPGnU2eN/DZPkM/C18o4oorYSwKBRVALq5UQwDxcc1VZON+
	p80t6apBkrmpTwuHltBg0W6pQqPY3lJOYFqsLbY5rJrFudRVsj+OVclmKDp0mcWpVeVVrP5HQ/V
	W8mcoDSLgdCVGk+Vaopjt38Mp7Pk1FfQSxHVGsCIe389pPQmW8xcb/MIUaNpj5iu
X-Received: by 2002:a17:90b:3d8e:b0:3ac:8897:7baa with SMTP id 98e67ed59e1d1-3ae8979a140mr13152373a91.40.1793831430846;
        Wed, 04 Nov 2026 14:30:30 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31638fdsm743618a91.8.2026.11.04.14.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:30:29 -0800 (PST)
Date: Wed, 4 Nov 2026 22:30:26 +0000
From: David Matlack <dmatlack@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
 mount chosen by userspace
Message-ID: <auuyAseOISaOWwbO@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-8-dmatlack@google.com>
 <2vxzecd0k1dg.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzecd0k1dg.fsf@kernel.org>
X-Stat-Signature: 9g61hhugehi3f4hyhzuxgoa6i1yq8ypr
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA86B40009
X-HE-Tag: 1793831432-175313
X-HE-Meta: U2FsdGVkX18C/xjn30eifQ9oza63j79aQ0XUWMe2xdvppqu87hatXqWS74SJjUwuqNUZUJBFh1Um1g5pEo6vpEC8evsvBxfjuYxpgudZuBBBdj58C/Pbf9W8biWIxI3nQZq3Lot9eObQ7vYie/c/HhjLh1J43hvG6/oCSwUgseenkbnMPSC5ClBXZfSGBoo+J2fXawkb9OcOF30t4Zmdfw58gIeIY/fFepLdXugFwTbs9hROl+4sNbwC5z033KEMcatf+yQNqiCvd1oJC8jHprU/159XcV6b4wdO1NztTaO6jCv1O/8HzyqR0VFPZewS2fvwfEIbizbeb2JweFTaT77vcrPt3O1K2x4EPMjYp+CXU++y2KGwNa6zkyq8eamss73ZlJI7lyD2a+6Fyj0izWlguX0dncIUHg70xiyAZVO0CWFBphkPukPaO3V4PecW+E4VRAOq3+NZiceztiSsobz73qc2l+c1t95jDo9ac+GwcctjhGhnApmux9OCIpEdApRnkEkeLi+rSvTkjTZX2N5aM2KmQYp4shu+5TslYCUdKmWlBUfcqJ18/A1+k3lyYy7iEkstKTCa1P3uzduHzSHhEXVrYZbjZEKpbso9o7n9H5hOnGi35N5e6RrMCSqV+CYwMWDfDFiFNDiOB3ZWN3tjXeGCCRIuKfEoHbbmD+WRNZ+v+UqRnhByHWLP2uoR29xwbcl+b2AETRTXvNOtyC8PvVatumPocurYzpSsglakG04Xvfoe9xoYLaXck29sjOPpiUtiLCPMqF2CfPL9ARLiu4kIDO3mBBzYPV+EuaLM2qJtr0U1E7SlvuH2HTHYAKRFNqirMxRxVIaSfkwdP6WbmLaugGqeXoGNg+QAfKivk0adnpaO2Xnwm09QTK6nUyOB9cTcPivpIurjuUJ0Bgv28lO4Ya6aGqyJ5JXypHE1Iu9i1Wc0e5HF/j57JrhIzfSPWvsZLiwnh6S0oGz
 vM1shDmC
 ggjsQpGTztuqHFuhuoI3wJQc4QbIP56U47XxtrpZVSYnL3YIkO251SXci/epd0mz4ry+OaRuBn6S8pUNBPFMAKvqkPSb543qvpgb7lnEco2SADeOfPMsnVvzDNPaKZwd1XUBLW3823MKc/IFkMwq9SWdLjLg+RzqI4U8qgL7c9EdZHKbHkuFN2RrNd+n979Q5syYli/sN6Xe/hnONqiUZA+C9akNK64mr1Jd2PYH/HJqRgHPfzW51kNiw97srRa6NZSMa34JnZejzKJdlyR9YrdTYcOXBGD83/sFU7QHE7dTJb7T1viH12GI848ZvvZVQ4Ojjr1JYLVtM0Aqycp7A48JMTMFxqT+ntAfHRJtIXU+g55c4EfEaQXTSTowIXUpHITEN5G4sacrjdKuPD4ZsgJDqIku2k6nzZW6Zl2YrnAwfkQMvMpV7HUzlEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 05:27 PM, Pratyush Yadav wrote:

> > + * If @flags contains unknown flags or O_PATH, if @mode contains unknown mode
> > + * bits, or if @dirfd is not on a tmpfs mount, the retrieve fails with -EINVAL.
> > + * If the file can't be created, the retrieve fails with the same errors as
> > + * open(). A retrieve that fails before the preserved contents are restored can
> > + * be retried.
> 
> How is userspace supposed to tell if preserved contents were restored?

Through the error code, like Pasha said on patch 3. I'll reword this in
v4 in terms of errors instead of kernel internals: errors from checking
the argument and creating the file, e.g. -EINVAL, -EBADF and the errors
that open() returns, can be retried after fixing the argument. Errors
while restoring the contents, e.g. -ENOMEM, or -ENOSPC when the contents
don't fit on the mount, are permanent, and retrieving the token again
returns the same error.

Thanks for the review. I'll address the rest in v4.

