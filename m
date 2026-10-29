Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742ED606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=fxYwSXx9
Received: by kanga.kvack.org (Postfix)
	id 79D726B05B1; Wed, 28 Oct 2026 20:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EDE6B05B2; Wed, 28 Oct 2026 20:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D2B6B05B3; Wed, 28 Oct 2026 20:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30DD76B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:04:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 847B21202E2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:04:46 +0000 (UTC)
X-FDA: 85373717772.26.CA3BB5E
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88666C0007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:04:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fxYwSXx9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793232284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/xBVtBLk16U8qItuEo0/3JxmIlfapOJCXoA5AObKSA=;
	b=29LEjJMngRDVSTrGMYorC6hvEP/SEp6LI9usy7eA2oKbKMAt5ZYgBjTvv2sz54fzW2MaY+
	CP3gvqru3AS6stLNj7rLDd9QjV/LpEjQLTQCLcGoaTU4hoJKHocXLOH1HaVpLet8mM7DPc
	fJYW1UcDn9LBIpu5b0qGVhitfv6FTHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fxYwSXx9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793232284;
	b=o17/nnnBbFKYu3QT5O7udh9PShrj15S8QayBGTdBpJC5Vc5wZK2EC4a7PuTZ4pgBy7hs8f
	7wIoUdLlK4DMOL51WvulpN2mmK2Ronk5VBfePmbAjUxwYZdXwx+nsqyd+AR58Jeaehc1ix
	RNdDPA3H+F4/JaGr08ArZDUkCkPIHr8=
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-9903fde8db8so463506241.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793232283; x=1793837083; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q/xBVtBLk16U8qItuEo0/3JxmIlfapOJCXoA5AObKSA=;
        b=fxYwSXx9B0sXGDeiR8RpG5dKTVs7f2D+xn8m8cYwnqPh5gaghFm1iKv27qLE618atK
         yEnjTvCD3zdclurLSqN+slq0VPwrlzh/x2rHwzEMstZHV95R/uwDt08xQdbxXJoJsRjS
         YyVKAVrfV+1AM8+VuyTP7bq4LmTuxNTr5T6v9afJDwOdDpUj1CWa7hc80Ngf36eciJum
         Fe9ZjuFPnZkqyCH/iVRXXwP+iubQeqlHw+i1z2DXv55y2IKsCvFSesVBpVxBvdUWdJqO
         oAtKKFAl5LZKTTSH5fdG2Zh09yhfDEG5hLYW7RhWpvQiIvNyxCUWlvghEg0VFIp/XRcj
         RR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793232283; x=1793837083;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q/xBVtBLk16U8qItuEo0/3JxmIlfapOJCXoA5AObKSA=;
        b=BY4IV7anLrkG68XRkZcAO4eIKz1j1xwDHAq4Db3zmOxemp5ro0GHZMTYkr0+QNB4aN
         BCHn9g+TDL3wq9tHCIsYFlWELFF/ef/os2Lk1x+DzyhpJKONYbTo5r/NyV6Jp5gKpMwE
         46i6CBPLH4Y12KJ6T8bV9XiOJctXPribjlBLU0vkcdCyC20tW1c1DezRCi+kgc25CoFk
         09ff4tWEUcnIgqeKqFr2EDU9nT1nwZuA43QWAQ/F7SwhxScUOKxPq1PfyAdxEkWMLJYn
         o6/jUg1Ozn7da9sOfM7l3srPySEiyNMQ18DqKXsRB7hlRN5vcUEXulQJvGnxx6ePGsq6
         OYGg==
X-Forwarded-Encrypted: i=1; AKwUvBwrK+3BL+HPakN0oXVqiJ1LibpAsfMooH9Fww+mFsFyo2PC+rtSO1Mb+eWxabVxicDaXEm5cxNV4g==@kvack.org
X-Gm-Message-State: AFq9FYK6b+pQMVUEn0w9/aQ5Q2mzgAzC5Bkgmou5u+DYlZ0EdoeR9Bai
	giQlCzRqjIYKTZHhVpHwSrVrN36npVEEPcE4OENheYk3cVaxWlY/+54cULF2v56l1Zs=
X-Gm-Gg: AYBFou1POj4One+3tEOqGjY4L02zSJ5XqLjmwStgMPfIE6foVh12272IhvKRAaPvLou
	ZQ7cGzF0JcN3uDaRgy8U4VapaL5eYuEA1G/EuUJ5nbkIpj580TZJEXQsiXjir/eaep6uRLLdM5O
	p758AY8tcugzJMRTPf2dkKpulDkEo1Yr4oE7ccQjjE90StwKrbLtswefAFQXlw+1Srh3ywEWa0U
	kzRN3jkAcraXQNG2yE8680JaL0Vt2AyZ9KJJssOrIAySUKRWXr/DgfM3b4+sgrG1P308gAB8C63
	RsIS1/sypby58TXKlM7tBcVrmliSWCXvsi4WBQ+jrQwqoKBhS1lIKEkO4BKjZ7Kd+cuh6z78VvC
	uMluDlWtRqwkfH/pUYnsbGsnOiGDaMX9h5xvvRZsARVuJYdFOCegkkCMCjfBZ2edE6v+HF6WuL2
	Aqi9QIFZ+o5j+D/Cj2GmiIuVafkEwmMDkCil2TbLgnsN4e5k72xDdDl3p9SrflhMRsAzuM17CH2
	AbBkG1rh9zVP5cFP42Nrx0lMiIlF0dxCNOqEsTjxPx2tvWIXCxiLcSxma2wyXJkNr5lnxdKFNtX
	MzWl6qoriHupmf42zFG3jO/aeY6OAXQ0b4FbCrOnGwvwKdbMSbK79PkCJWTr/whxhaFfCxoXkDu
	TNQBG8Ki5Rm+GdoIRpdBFYO1Jli1LqDhO
X-Received: by 2002:a05:6102:3e92:b0:7b5:1ca4:9df1 with SMTP id ada2fe7eead31-7d03a29c54fmr1908368137.5.1793232283543;
        Wed, 28 Oct 2026 17:04:43 -0700 (PDT)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99125931983sm7622737241.2.2026.10.28.17.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 17:04:43 -0700 (PDT)
Date: Wed, 28 Oct 2026 20:04:42 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
 mount chosen by userspace
Message-ID: <auKND0n3LyivCrir@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-8-dmatlack@google.com>
 <179322496574.1894369.544573858973645958.b4-review@b4>
 <auKAlcPN0Lt6Y3Wm@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auKAlcPN0Lt6Y3Wm@google.com>
X-Rspamd-Queue-Id: 88666C0007
X-Stat-Signature: ecbxm4f45awgdu1rey6pp6qsok3mookg
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793232284-551928
X-HE-Meta: U2FsdGVkX1+CarD+jDAQ8m0oJD3VMDidRU/0D/NNlUwOQJ641wdCFWRVdU0qO3hRqn9HPWw9sh7vd+Dhx/N3qYI4rXtQeklRH9d+ENsjoSn6XOiBFs6DlUmocbqxqIKH55HqpzuDYssdDU7/GDC1JEqIt0KhIC9TkjXME3ApqXPu6t/aj6kY1WzpJDHhvM3BhwAQm/onXGztyFZEFDoNuauMYEHEMookVSb28LTVGda22bljSVkxqWf+AwlNNMX0TySKg0lPFotJP3/zQqPSR81PwF6P3o/euJUOu3vak/+Zady096ygFUi6R1QictxU3D1f9gf1B0npoalp5i+6YfQ+gJSLQoHMeh4ZvKb04X/mg5/NtuqijOwX2cGG82O5YkASW4D4uPRihXyTm37X7nr+KLQh3PvKOY7M0DsninHPX69yODvkPz/lxy14Wkt0ugXPdxLloJLpPjUoZMbIsvgom8bug5Iy4Belw9petziODlE0ujyhct8bVTFRYWMkIV8nFuTsQIotLkmyFIGa2tWhLXp7vN3d0OY2LfABZR22bhiiRQyRj7QgG/QtQyV0gw0VKRLOjWph6p82wV3JEs3iP5l75GvchMFQDi/+QpBW0o5qEtI71/MgtW2haTAM+KB1V1jTZNuMvcKF0q7pMYIq5Sv0aLjdnQstx8AmP0LtgV2/2FePNZGq+KJ6hgz9IghLY4bluGD/dYS+K0Yt2mEys2bGtmpWSrmTbsxNBADGpv0lZdjlF/Kwff9mL14EOkMZJ1mjUqDmsznwEDJnx+O6X0ZUn+DT51sSads+e4fuzmLrNcaybwmbrtlBAWU5NXjn2+tpmu2TTInpLfE30LBiUOPYwR5bDSAdbd7W934/eZ+JY2/IQIBmWDLgpcrJtTACIlgxedC/pddDSQedXWJijEvyOnTFaofDWo6h9Cmgd4x0TTfi9trKZyd8by/WeXoTsAEWfzFjgotCBzx
 MIcT5AkO
 trsVDVc91T6Hrz4ecOtjyJIG9bJW+0S9ejMpWhah+O+akcF7K6lrgwHSOq1+SiIGNqwO8MgZcmtTOuwXdvzQdH8aBzMREXGAWwyg4dinn2YlqHpVwsvDuHrNJ0pygLWKwkFbRF1w0fvH/XCfqI00pvHWF6zWMWX8y42EECTJd3eSwIvgDeUN/XPW2neia1ow1dHo5zwlAjAJ8TKaR+PqCsUv8PARTZ6Dsd90Tl7fHze0tm0QjBl6TA902DR2M5VodNUT9NwOL0r/HAijI9VtmCZAKTQdTh90p6t6hLmpiJ5FhWEE8aNclZRyLenOvKl3aOvu4zSnX+2gl2ocJaNcSOiMqvRd/fg72A95vMg+keYKpuwLzO4pYfTI6Noe28hgHwnmCuZmJD0Jsh0qFckHacPQrU/hJL8iBpVOAKXyXaPAjbQwSdmXJ/gXPDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-28 23:09, David Matlack wrote:
> On 2026-10-28 06:02 PM, Pasha Tatashin wrote:
> 
> > > +/*
> > > + * Whether @inode is on the internal shmem mount, which is used by
> > > + * shmem_file_setup() and thus by memfd_create().
> > > + */
> > > +bool shmem_inode_on_internal_mount(const struct inode *inode)
> > > +{
> > > +	return inode->i_sb == shm_mnt->mnt_sb;
> > > +}
> > 
> > Please fix the warning reported by kernel test robot.
> 
> Will do.
> 
> The prototype for shmem_inode_on_internal_mount() is in mm/internal.h,
> which mm/shmem.c only includes if CONFIG_SHMEM=y, but the robot was
> building without CONFIG_SHMEM. I've moved the definition of this
> function into CONFIG_SHMEM in v3 to fix this.
> 
> > Looking at this together with Pratyush's mapping-freeze series ([PATCH
> > 0/3] mm: allow freezing mappings), I think we should extend the mapping
> > freeze lifecycle from preserve() -> retrieve() to preserve() ->
> > finish().
> >
> > When retrieve() returns an fd, its mapping should still come out frozen
> > and only become fully user-owned/mutable once a successful session
> > finish() happens. That keeps the index -> folio mapping invariant across
> > the entire live update until every fd in the session (e.g. vmfd,
> > iommufd, vfiofd that depend on the memfd) has been retrieved, passed
> > can_finish(), and been finalized together in finish().
> >
> > (Doesn't have to block this series, we can do it on top or as part of
> > Pratyush's AS_FROZEN series.), but I think we must fix it either here or
> > there.)
> 
> Ok that sounds reasonable. Should we do that as part of Pratyush's
> series then?
> 
> Pratyuh's series replaces shmem_freeze() with mapping_set_frozen(), so
> retrieve() would freeze the new file and finish() would unfreeze it.
> That should work the same for memfds and tmpfs files..
> 
> BTW, this tmpfs series does a lot of renames and code motion so it
> conflicts with Pratyush's series. How should we order these?

Initially, I thought Pratyush's patch series would land after yours. 
However, since he plans to separate the LU changes from the rest, I 
expect both series to land in this cycle. The order does not matter; 
whoever lands in liveupdate/next first, the other will need to resolve 
the merge conflicts.

-- 
Pasha

