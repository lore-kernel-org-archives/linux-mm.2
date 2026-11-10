Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB327606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qm0sZ2Fq
Received: by kanga.kvack.org (Postfix)
	id E807F6B05B0; Tue, 10 Nov 2026 09:12:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E582A6B05B2; Tue, 10 Nov 2026 09:12:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E426B05B4; Tue, 10 Nov 2026 09:12:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B248F6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:12:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42DBDC08B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:12:43 +0000 (UTC)
X-FDA: 85419400206.20.352657D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8F627C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:12:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm0sZ2Fq;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319961;
	b=EPCNsLQzmnPwu8Q6WsOIIE2fyMkwkV+hHA0yKSzwZ79Wt+3c2qgQu47xfPM1K+I6pKceLY
	Ph9oPpaPmj5Vb+KxJerJ6ZaVT4E9fQJw9GStgUbvVU0tXksotAu0qLVsPCcZsAcN9w7ajR
	cz+2NL2nb/JUzkjpysBgG0GBWAPVY9Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm0sZ2Fq;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VgY6UdWu9zLmnF3aLHQsmOuzao3PITWEgw/5e5KuwU=;
	b=wtHP8zufU4ZE1bRT25PXyJcy2M40OIDlZGR7hacCGwYyARnS5eeffC8SEnBFi/lgF3GoMz
	PUTuCwa16KOXE9xtz/LwDEZ+aUzJZ2MSO6QQnid1AqjjylpNSi4ygQ1o/vhb385Q27rE42
	IyfM0c8d5P0tQZc8t3cMYEwjoV3CSX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED00361CFF;
	Tue, 10 Nov 2026 14:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CB61F008A1;
	Tue, 10 Nov 2026 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794319960;
	bh=6VgY6UdWu9zLmnF3aLHQsmOuzao3PITWEgw/5e5KuwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qm0sZ2Fq4qPY1DKIKav6pqo7ACprob1rUv8p319SW6KFEx+TBxE4TRzcyKCZevuDw
	 0cS3uXOaW2KCkoqT8UtoX0z0uLH+IlOzbaDYK1NJ2eUKWPbwmLU9//qxzJMoLkU6cJ
	 z+KJzWh7p3OU9AP5hvCXIM/QjG9Y3VXFoWkP5jvm1xaEGEiE2FDCVIKdchuCWU6LB5
	 A+OF2in0nAygQ2p7Rnv2xCqKveTl1hrNC5jmHhshuWoo7YxUYQdDBoW+TUzrER2nUx
	 S+UYgfQUl1O5/x03wPgGptiG2nqhteMr27xLsPeRmuMu0yZxubY3OoAAJWJlzyUjXT
	 ogs7KmUEotdnQ==
Date: Tue, 10 Nov 2026 15:12:36 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: =?utf-8?B?TcOpdmVu?= Car <meven29@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, =?utf-8?B?TcOpdmVu?= Car <meven@kde.org>
Subject: Re: [RFC PATCH v2 1/3] fs: add filename_utimensat()
Message-ID: <20261110-ohrfeigen-broschen-quartal-28599cd8e172@brauner>
References: <20261104110604.126717-1-meven29@gmail.com>
 <20261104110604.126717-2-meven29@gmail.com>
 <35n54rrx6qq67j4fpxlvh67hal7zhmke2g5zcuhs5sbvxy22ez@nnnt4r4xng4r>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35n54rrx6qq67j4fpxlvh67hal7zhmke2g5zcuhs5sbvxy22ez@nnnt4r4xng4r>
X-Stat-Signature: 1o67msrkwz7jrgjd81sfuwpghtuyp343
X-Rspamd-Queue-Id: 8F627C0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794319961-819548
X-HE-Meta: U2FsdGVkX1/eupZe6eCr5vvfpM/oAeHw/wxkw/vmxI+SyRbE45zbRdcMHjdUAEo9y8zr7JjCaAc1iXaUZvx1Cv+pitPaQ7iZgaUNZmIsUQ8xTm+/62apQ+/fO2sPVl/w2ir4fu/oKf89jFdkYdb+l0aUTkY5WEiVIYvRSwOH8m0A4L2NzTTuInARgbkTtWcFHNmvQvMulT3G3dEcuRgpPF3rT5vQQtZzUnFOMf9tCDHhz4olkpXjOTtv9f2OTEfgZROtO2Vfh2ya0stu+0tTgSMAkAcsKtU11fIAmqBYt9HZBbrSf+g+NjehinZs03m6IiCYBAGgL/r1wXPt3a2fGLXUQsZLGANjOdsSbCT6Vs+CASn+9D5ancxddAZkrAPRyrY7gZH4lWcYG6Rr36A3532jBaZNL6OQD276boT088Wxjh44TKUOfOnYQ+LRuoWFX8Tu0zjZtNBUo4d+2xsG+9cRWoOoMbaThPCfb8PdANBL2vxFn5mjejSIPgXW3Eu/yCK3LZRwuMgJu/M2DxlpwBoKPjItauAskqgNAPzaNAXrWDMHS1H48Wf2nZQ1RdixYNwrO2dxVYbtToPQbFbMcufnEAalTVSunbdiLzVQsyhtWyppLwyUudf4oXP6AVWnUaztmx5wDh9LRhBP8rVZlbL9lK95pSVv2WqUGjbsnW6GvbGdFHe+UOEh/DeUWIdhsaD7yB19h7HMzkq/W2qt3IB7Acc/YTGMEbTPcOlOMiGgzJPkb+1DwAWr35lonXLFqrzfii/ceTouEq1oTxEGA+she3TFduBqznzcmTWfMjTvxF03eDxt94/V3wo+hCGPKH1iNhCLu5jdxFkI04DY6aFfx3H/aYaPFaVsymEOcF/X4hX4+m9XDH93UlC486dEtORvbo3ZCskneeLXvC4F+di1/XVh2f7FXNJ9GiigNYozpXDDdyXoXRO1Iu4tbu0Xv969JuHNcG3b8j9dmMc
 QsaFqQy5
 36JxSqmNf1/BgIfOzn+vRHBkkzfGAcMaOtFFkET02JYlaDwN9xL8gGnWyfdbTgTBuJm1dERrLL2owsLWhfZPDs1azagTU1suRDyjXGNK1tGeRVHbmmy+XYxU3Ati6rRAW4xLQj//YHNtQeeuz0Ee0IxSlk2qfgcF09R+G+d4IolSqakh+CBtEuQF4gEwFaYR3VHjjih01eYSKL/saiG4mi4Ey+Gm+FMsdaJaD/OTl9eEZkNHIHBIsus6WHMmjCXc1l4KXAFddm+DDaavB2nuqgEseVgPopPT1HGXLlS2BU/zE+DCE92OJ5ch7Vg20SKTCHPBUFt/gTZsQQesxW0hXzk3EoCKx7mGAsKE0EHOW2FaM00dBGszPD0+nM8IWmk0G4y5DkQlfBg/+uuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:05:18PM +0100, Jan Kara wrote:
> On Wed 04-11-26 12:06:02, Méven Car wrote:
> > From: Méven Car <meven@kde.org>
> > 
> > Copy utilities that preserve timestamps, like cp -p or a file manager,
> > set the times of every copy after its last write. To do that through
> > io_uring, the request needs the utimensat() lookup on a name that was
> > imported at submission time.
> > 
> > io_uring takes the path of a request when it is submitted and looks it
> > up later, from a worker thread. The path ops it already has call the
> > filename_*() helpers of fs/namei.c with a struct filename. utimensat(2)
> > had no such helper: do_utimes_path() took the user pointer and imported
> > the name itself.
> > 
> > Split the lookup and the vfs_utimes() call out of do_utimes_path() into
> > filename_utimensat(), declared in fs/internal.h next to the other
> > filename_*() helpers. do_utimes_path() now only imports the name.
> > 
> > Signed-off-by: Méven Car <meven@kde.org>
> 
> Looks ok. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Seems fine.

