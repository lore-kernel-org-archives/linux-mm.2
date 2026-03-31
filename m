Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FDAFF60DB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A966B008C; Tue, 31 Mar 2026 03:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB5F6B0095; Tue, 31 Mar 2026 03:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11A06B0096; Tue, 31 Mar 2026 03:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF9B16B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:37:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 976CC1A09CE
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:37:36 +0000 (UTC)
X-FDA: 84605553312.07.7582725
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id B81B11C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:37:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FP1spozR;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942654; a=rsa-sha256;
	cv=none;
	b=ltxFAMYsYPTErY4AquGq/mzjJvfkVb5gUj1rhjBB1BIUP4M6WENJ+gQwOtk5EDFsTW6oQY
	hDaVALhPPPkUNDOvyGU7L9PgBDlVrghcmfnxuPRZs6ssPvT18biK1SbCNTWJL6E2k8IoL+
	t+o8jYMaBHnKFczxdP01C4WUyhKmVBk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FP1spozR;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zB4K43acGXLF9/IX+A7nsvuZUclZzkurqbD17TuUhE=;
	b=YGfGrnn69PLl7OMJtaDLqgIvMMH1sEuaxeCarMtbTOslSYEL9LHs2+7jYXIHyhQXgRyDOd
	Y9KfGtPvC79C1GPTFaJoYcHfIerIcrxWIkIa2VvJBJCL71xR5heYZj4krqjtDTtkmr/i0S
	lKns3WrV6NpE0IMIiHtLTXy6w0ABDvY=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b24fede2acso13455265ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774942653; x=1775547453; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zB4K43acGXLF9/IX+A7nsvuZUclZzkurqbD17TuUhE=;
        b=FP1spozRpwufepFgWBCKauoNFGJ5A4eNpfxfW/IYYCQplOAZqf9m2ymXmU8V0Hs49t
         3Jupa+WL7tLMagMKXKuUqjr9ljDsuR8RIMM1uTHkhVkPHtNVGYOEixwG/wiw9XeiZLcN
         x/FJib3tLcrERnF4QDUcsNEr4DU2u9Xto5kMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942653; x=1775547453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0zB4K43acGXLF9/IX+A7nsvuZUclZzkurqbD17TuUhE=;
        b=XYS6kT87E8xn8j3cVy07IAFN4aQsobARJYbgx67L67SJRbqKWRAJHY4O94J6Iz0AnC
         IdcvzWJrTOagy/w8gwLcF9L6Iw/DZeHRibyu/SWl/+D8V+t5CXb/KBCDJsmZRmiW0an4
         u+/PzGn1DSeAiISNOOq6WuiR6Fm3mKUm2U6KSPzUhykluNIEZbutsRHjj+pqnrEzC2LO
         GoUIJ/UmY5HOxkXcRSu84yVd2nFGyNMnmBHcmvrr03ZetAOfHM2J8NIkd3e5lx0RwKqD
         aQXcobtz5RKlEh3QE5WDoYWvrxUqk8RP8ZGndPdqhYpToHhBBy5FzMTej7hnUOrDOiRA
         EAjg==
X-Forwarded-Encrypted: i=1; AJvYcCXgYRxEIOkNXO+b+KJO0sfgqDEC5EPuVfTohdKzJIXMRZI5Uwyw2EyGMm8fXRx1EKR7rGZV+2HQXw==@kvack.org
X-Gm-Message-State: AOJu0YwgmCsX69pYxyDQt8Xo2lZ6d6bbR40bfpzVp2jrfhmasBRTHHDE
	m7MUY/Ew+c5WeWPZdJFXW1ytYWOKzEWNiZvdME8C5kxLyOACIMo3FcqDnzCTf4s7oQ==
X-Gm-Gg: ATEYQzz6bfSeSgOxCsXWYFIW+plpM+CzcguZ7xKRWWjlc1C4QGyUpa54IZPq0cFIwBt
	D3aKC+cEFJUA5Me5ALSTF+RsJh1QgF9MkTHFipyJrGeZJ8lmA+RuBOGgNJg6N3bFRAWtzu7P+QW
	QqK+CbEqa9Qvb4JVc4LyHsWQuSX2I8Sw4mgz8u+aHpWj6opG4+Qk1Y9Bf6oBlKPL98ulAf1ulaJ
	MNO3wfstOs0FHkk81s68M9JduxrkPeNeBCTqm5SErVT2GSyGe91fRzsRTjG65cUTQNOX6pq6CJe
	FQA5SeRNcrQuvm+I6OeNJCmcObLJZUu74/9OzIOH1V/Kamc9I9fpsDLUNVgDLIQEJbDdc9q4FjL
	tLZJ65HWeNux+9PGMIh4F2aQiHKAlap21F+mW69XTRs65t/hHzQEo+Lk8nGGEeLP4KhdIINO/1C
	TecCcgMZSHN+0sYXCnLV0rVaUJv0YLHxMlUt81UMotKC/BdmH2XJQL9+piLWNZi5w=
X-Received: by 2002:a17:902:db0f:b0:2b2:50bd:83ac with SMTP id d9443c01a7336-2b250bd85b6mr76653425ad.40.1774942653595;
        Tue, 31 Mar 2026 00:37:33 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242690e60sm102404315ad.37.2026.03.31.00.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:37:33 -0700 (PDT)
Date: Tue, 31 Mar 2026 16:37:29 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] zram: do not forget to endio for partial discard requests
Message-ID: <act5XhgtqrtN1zdY@google.com>
References: <20260331071537.706139-1-senozhatsky@chromium.org>
 <a6b566e8-5808-4244-bcda-5612760bde3b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b566e8-5808-4244-bcda-5612760bde3b@suse.com>
X-Stat-Signature: k3up9cs57ch5yofabq1p3jpp8ceyz89b
X-Rspamd-Queue-Id: B81B11C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774942654-800567
X-HE-Meta: U2FsdGVkX1+IpdE/SpeC7TSzJ8GkgcC7fu9pnAU5BrdrjI8ldyKiC54aynOZs3Ko+7Iyovv9wZOoVf5YeFZb21p1TSbHdBdOngvDworYof8QTJNYGMfHh3aXXD/ZkY52eCUKZ+/Vva6Hw/aeuhhXtzqG29nLnV9lRA2YkPl680zwgl8YYGs+HkyW0JyCYq2Ich9f8fFDyAntvyO0f8tL6lOWx5vt/ANOJbJEJexrtLcyZKCNILPsW5qr9aK5iE38PLdU7HD2QidsI0zpQVo3wcaaUHxQY7M/JfQa2An9/PQfFu50thyAnhI3sc1ehSHM3YcCcihzwWQjgC4W84liJLU2Hwn+a60NGMpaz4uEj9XE1M4drVWEqN0lI0yw+ezK+oJQzNOnF0LyHqqnuFHQnP3M/g6lB9cJV+vwnsF2s2N+biGJeUGmd5fzsVwyLkMIvEyTypIV7hglAb8Oz6Y0rXQ8cNliypboB2t2+oYontLFdka0wwYvuiQMnhginTvVNz0j5ur+dFSM/I+j/qsvSJS2yP1Gb1uxTecnnTeF+bTPH+NNfx74o4qnD3VgNQ3ryQXumNTYUfH1SA4gF+Ue8FbLTEQxdCfuu7FD6O/yYZTECLPZczVtyByAZJ8wMD8kDMMXt/nOH7y3hvbKUeUIOFrDwQu6LJuQ5YvIMsISMSg1fVfHXSjFh6+loiDgQqy7fn1JyvdXRGO7zICn0WItDm1n0cwa7i+jNmEiPXlamzz0i3CfLo9F6CjWGrPPGxE/iqdQk7f0bsxU7uUM6YEIFfWVwgqLYaPiOytszrALTRD/I+dXPSLwozk2j1vT+zAhqHVZkbswJtl5viOnZcyiNjXVjJEST6QJj/+O5CjSfCeZho6LWAqMY+f+1KEc+6A0qlGT7mdsxH+JqGa8/gN+3iB+zuJZFpEVld4Xkc3FkdnsDK2tJsQlbamGUGPFtEQGoVJ0vwvjzisJPtu7A+e
 pmzt9dVB
 hnUgoXv0D4LR4pBqxW87ZO5OmOCrEhhn52BhIl3Vl1qH0X3ftcqNawqJeuklSlGF5Bf2yti4UaY0iQqy1X+I8OCgpezD5W2qR8ahNxhQOKOKUA+ed9GVgOV+SCI7922FKApik4bxf8nTQNz1Xnpzzk/xrAm6otf+e+v+FgUWmH2EkX5yUd4PNuwc5RccInH5y7h8iowvJNZdcbfpQmBthR0anEjTNKIHHXPrr/+5/pw6QXGDxFv5cOmcYDH5EYz2bKxORGrCWtKcuD4mKrybXCd+6ZjQ2ei9BF+9K7F0r2PL7+cNaoFPIf+u3zFGwXM4mZeo6VI/hgHr2EksQ3WwoyhCm9MniYaj1YbVj2o3MlLoP8O4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/31 18:02), Qu Wenruo wrote:
[..]
> Which is 3 times slower than regular block devices.
> 
> And after that short fsstress run:
> 
>  NAME       ALGORITHM DISKSIZE   DATA COMPR TOTAL STREAMS MOUNTPOINT
>  /dev/zram0 zstd            1G 271.2M   10M 20.4M
> 
> I guess this time the overhead is just in the compression so that's
> something expected?

Yes, pretty sure that is compression overhead, zstd is not the fastest
algorithm.  If you need something just for testing then lzo or lz4
should be a better choice.

