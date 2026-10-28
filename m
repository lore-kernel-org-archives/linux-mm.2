Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778E9606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 23:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O0Ipu14r
Received: by kanga.kvack.org (Postfix)
	id F280E6B00EF; Wed, 28 Oct 2026 19:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED99F6B05B1; Wed, 28 Oct 2026 19:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9DE6B05B3; Wed, 28 Oct 2026 19:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 772E46B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:09:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA2D48024D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:09:19 +0000 (UTC)
X-FDA: 85373578038.02.6FBD6A8
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D7414000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:09:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O0Ipu14r;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793228958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5xA2wRJBQ07Qo768sQziuchQxKB2Cjd+x4z5GHdG10=;
	b=6T6Pzl/evWDEBGhzvLDamlvdgmSyhcMa5vUO6sT5QpKZ8Fd41PoENbAXRh/Dbhg/4IXwM3
	FfrjM7OSd2oixtz5ZifEmC1IbYZ/0AzkDi/syMPbcwkmlF/q2Pv+9J3eEUCVncXfKixqkV
	TX3sa+6gSFmKCRq0Dj62McFG6Gcp/IY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O0Ipu14r;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793228958;
	b=m3CI0D4TveD0B+4nsE82kkdafMrS6KgU+aZACFF236RhasAFkXQttxa7i++xk7C9ES9ViB
	ID+2/ZhKX5Ggvg6VamWyGpvzvOLP/MWxN04ZaWrw1IlWPs/4ojmbBs9cTupcUtZSAKfDHA
	JrxerpSuS4DY9sf6SWpmHyk2hd4QR2s=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so921409a91.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793228957; x=1793833757; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q5xA2wRJBQ07Qo768sQziuchQxKB2Cjd+x4z5GHdG10=;
        b=O0Ipu14r7VXGbbA39CEd8nv/jkarXNTu3vg4sNeqCl21CJ2Ou8Gs3MtUY1sB/gI56x
         4FIoUjAyIyBnesBa69pXmLlNZpVO301bkINMR5lTNMl1O6qV9DeyQv6KmR3WqsLFhBJY
         QEMHJiC0u6a1ecIkHzwithkDj0UjpGDoqg9ibOaKUu+hSbMggSOKGSXrp18FNvfGLCjM
         bXP4crpxPNuLqXyyCr6y0pzRj08o2nhaARwHPxl51Zb2Npg+/4eLWEh0QQGro8ht0cHc
         v2fzYYE+P7S7F/WM7IPgw4pQgTQDWNie6p6xpT6ScB1P99xU6fU8WggWdDItFyIUxNLp
         BVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228957; x=1793833757;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q5xA2wRJBQ07Qo768sQziuchQxKB2Cjd+x4z5GHdG10=;
        b=keqAK99KkHmppOB56qZTvCaN4BZHrQp05TGr45lixdk1Rn+b3trUBzTuLlU+GhaIbt
         TVBmnw7Pav1waotNp9SKvuFDmIYGj1VG2f3FEbUKqRsZxtDDlpymBjOqp/YFu7kuds6n
         FVp9vCfJhpgSrf2aER3+NgYXeR4mvLBw3gEk3vqDNbmurA1WnBbQr/eMgCDx9oIoIKaD
         8mIHcqbkutOVUzmNAkB1UhYcWjJwDWiMQlfJZHdnj5sBeMT5rRCZ9fU9qo0WEbK9U6j0
         LVbm4vM6OJYEKmwCcp403uSxaJwyn9Lg3CUXJfJEZD8D5pW0BG8B2BADLIppLZBhFa4s
         OC5w==
X-Forwarded-Encrypted: i=1; AKwUvBxfo2PFNM42cpbbsLYm+tlxknCgfWMWFdwLhC4bxLpGY9iPhqtz3U8SXMRKb16ZarwGtY7j97s9Zw==@kvack.org
X-Gm-Message-State: AFq9FYLjJTDiZCLpTH+4yPDbb/TCZpVmMp40jSuCa1B1hGABafnToaU0
	yP/iCkXtQxpuL+lFH8W1+OguQoKDcom2BwGOQNDl00fSfYjHy+1TqPg3i42j+NwqWg==
X-Gm-Gg: AYBFou3rUkMKOHUwX9EKQdhv2i35HfOcJKdzEftO4iYLCGStTMXt/m6mCXyRh39C+6F
	GivnETjRGenQvZMz07RY2RhseFeM2aFcWuCn/L5upyjgGQTcKwNMQACApj4lFio7x16rFuFH4P5
	2sHu1W13OkVwoGf9vZuqiufwe+KrBSQU08sWNUos/fsXHDT94z591F6icsD9hPp/6sa69q5hejV
	vGP39Ue33Z5B95dfXL+q7IH4sLR5Z+G9SDPInbw1jv7qXcfylJwms7hXNLPsDeQ1zEhIog8XTGQ
	M65V+qzhb8HlQ3CZSVnJnecrgRUZTINUh7autHMaq5wFELGBLo8kCIodnkvgP8Xa2T5r1t7x5zD
	pewaGTws2KlVgbGvdhhzF9xpU8SFUkMftXmmVxANpX9KurSwm6y+id09bJwigQwTnJqAlDxJIh2
	LsmUJFmvHE5LzVI6mrQUWZ/kIqHt9UpH2oa4uMg5hsNYxPbB49VtWYYPQ7WzpbHSPA51WlhDET0
	zaE8vXkh8PPswmglCymZ56Sbv4BX0EbDZPQySUNh2C2by0KfP1LQeoaj0Rsa94g8unIVwgmgKWD
	iqpxVs158HtfVOi3Lj590FLYz6VoIeCa7cDhYmlnVu9Lqs0sfSrGj4wISdDHtqT2Gg==
X-Received: by 2002:a17:90a:ec8e:b0:3ac:8897:7b92 with SMTP id 98e67ed59e1d1-3ae58319f5amr2770048a91.57.1793228956133;
        Wed, 28 Oct 2026 16:09:16 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e973ac6sm1327770a91.11.2026.10.28.16.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 16:09:13 -0700 (PDT)
Date: Wed, 28 Oct 2026 23:09:09 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
 mount chosen by userspace
Message-ID: <auKAlcPN0Lt6Y3Wm@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-8-dmatlack@google.com>
 <179322496574.1894369.544573858973645958.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179322496574.1894369.544573858973645958.b4-review@b4>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D7414000D
X-Stat-Signature: ffahzefhhzsgrkcs5zi89o6zr7rtgr65
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793228957-915862
X-HE-Meta: U2FsdGVkX1/yXsRG5IX7hY89+b6NOk9UJjMCQbMMaUrdS+hbH05hlTE8BtP0T+MdCgGr+wOX7MS7kUBOmfggJhkjW5Y5kRcL61gYP4/HMB71f+5jsnjrH5dFSRJP8vIkI5WCCYVOCSuwyvc4zh8scVIwDt2AdJgc49Ojj1Xly09fNmH/F6cg/B0bNn3d4zNtdSlMDK9NQxcyr2WO4vQfjV8RMbGl9M41O6BBBKcfNkFYRL2hivgBA2TBhZK/k8VBqh+O+cbyMR5gz4v1Bfoi4KRJu89OJZ+wOUpIOUtEd7emqE59+wKtaWHVZuddBKUi4FKPhaVeyr7r09SR3yFXdYpVY133oqqzR1nC1eGatG+QWX7xnEZNksTcUfuLsJJhCZGiD2Fx0eflxrMt1PQknIv4PQLZyLgCR2tVspVVr97WKi5d1lyiDXZGGi9WKyRDAQybgpgatyHMMOrB9L49wxO/g1l2pnGIm7g8VxRfrVLzQ+K4o5WtDAYWxCy+LhWayCZRptZt/3qayWPk5J3c291zEbqBiwgvpMnzyhyFgOxLKllu4TtDURgj0C8S2i+EJIMBjgtkX0N6vqEyYIYUY6QP2E2KykurxiGVYtUpQIuMwGinzfkbGyO3rt9oqa4ou4ZTt1EEqnhmAokHdppbHifyF5FTyWHwSJNX7ciq8EdisZCLRzgbXSnwpGUwzN159CkAFgTL409MIwOKxpJawc3eF6AvcvXDvfEN+WPY7O/4RD5iWRZO9Rf7F9TkoskYN0E9DGLzrOstPLd12gzBG2TF6Rj+7rekHSx6ussLSuZuTEqkg1lI+LH/EmevN7emVcipN9/hqgjLMD9YEMfnjXd1y5+We8O8HuWWYeWJ++fhEa4JUPHH72IZ+bttTdAZ5gbiGw4Dyfxg4tTlUmHYhbOytPjJ69mIodQpFvUDopvxUKr2M27HlzeHTfvknp+niZmUYL36yHdrZFkmVTD
 eC40KKls
 ZLMu7enlStpapN0UncRxSDcZqIjqH5hdtcM3qwxfvpLeadp1AMkUoUbQ3e9BI7w8yWPVkCYxnV40GnSOkgsPL/guTSJEC2/DeAOe4DIBVkQ6ixv0X2C4Q/eYtWmmkE4c7focHbzyTWcejS8/l9HPwzw9Id8P+BCahSUo5y9pIBvmgSWLsvNs75m0+V2vGOVzsxj3dtaMNNqmGtCRm1GW3iweMEq6QLFUw1jrVDYqtZ4USwZtekcwmlhNbNjLyiQYLL79wqH8ClL8jPQVo1Xd9rw/EITLZaIhTQ2rpEN31umQcoYLzkTzAo+K/Gv7TBBKscD8b31Wm6TzBMAMwF7lsd76gafpw/PuSeiFNocZTvKlk8j+j3o0MxAR/K2raRw4RJsB6b/g4Zg/Z79dmEXOLYO5ImDp6G1q0Empv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 06:02 PM, Pasha Tatashin wrote:

> > +/*
> > + * Whether @inode is on the internal shmem mount, which is used by
> > + * shmem_file_setup() and thus by memfd_create().
> > + */
> > +bool shmem_inode_on_internal_mount(const struct inode *inode)
> > +{
> > +	return inode->i_sb == shm_mnt->mnt_sb;
> > +}
> 
> Please fix the warning reported by kernel test robot.

Will do.

The prototype for shmem_inode_on_internal_mount() is in mm/internal.h,
which mm/shmem.c only includes if CONFIG_SHMEM=y, but the robot was
building without CONFIG_SHMEM. I've moved the definition of this
function into CONFIG_SHMEM in v3 to fix this.

> Looking at this together with Pratyush's mapping-freeze series ([PATCH
> 0/3] mm: allow freezing mappings), I think we should extend the mapping
> freeze lifecycle from preserve() -> retrieve() to preserve() ->
> finish().
>
> When retrieve() returns an fd, its mapping should still come out frozen
> and only become fully user-owned/mutable once a successful session
> finish() happens. That keeps the index -> folio mapping invariant across
> the entire live update until every fd in the session (e.g. vmfd,
> iommufd, vfiofd that depend on the memfd) has been retrieved, passed
> can_finish(), and been finalized together in finish().
>
> (Doesn't have to block this series, we can do it on top or as part of
> Pratyush's AS_FROZEN series.), but I think we must fix it either here or
> there.)

Ok that sounds reasonable. Should we do that as part of Pratyush's
series then?

Pratyuh's series replaces shmem_freeze() with mapping_set_frozen(), so
retrieve() would freeze the new file and finish() would unfreeze it.
That should work the same for memfds and tmpfs files..

BTW, this tmpfs series does a lot of renames and code motion so it
conflicts with Pratyush's series. How should we order these?

