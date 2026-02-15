Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE124EF5868
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 09:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B8D6B0005; Sun, 15 Feb 2026 04:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D440E6B0088; Sun, 15 Feb 2026 04:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C437C6B008A; Sun, 15 Feb 2026 04:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B29086B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 04:02:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ED191A0AB7
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 09:02:03 +0000 (UTC)
X-FDA: 84446098926.19.D61BD1F
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5F495A000B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 09:02:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MR3bTnuj;
	spf=pass (imf15.hostedemail.com: domain of amir73il@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771146121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+D0ODJnkgxsrPA3UYy81wUrrkW2kcfyG+MPWkVZLGUk=;
	b=I8RusO4T2+2qKwzSUBXj/gxeIOAoFC+xVTGo4mg1oVhUg9OrZN2fJm+Kg8o/3aw7JOXRpj
	K/qxQspEMVaGe3HUWOEeb4fPDNmiPEwB0fiyE96D5CWWi/1ZnFnuFBjizZXzkmjU84ZwbD
	U3xF0i3HG1wuqn9WQ6hrEMbCdX7qL8Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MR3bTnuj;
	spf=pass (imf15.hostedemail.com: domain of amir73il@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771146121; a=rsa-sha256;
	cv=none;
	b=pbovw2FtbSaQdkY3HGPBlilsJH7Zn0MauLaETeVvfeRtL8dSYbx+dYAGjlcKfkvVeiPipW
	ANekKvkuKwnvjVwQvncowgZHCyIHcW9+o7zeCgOR6Wyb2VylObTWC2VsRNfbsLD2SPX19J
	hSzgJeCw4JzsngZU5V8LmI6CAARz/jw=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4376acce52eso1441349f8f.1
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 01:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771146120; x=1771750920; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+D0ODJnkgxsrPA3UYy81wUrrkW2kcfyG+MPWkVZLGUk=;
        b=MR3bTnuj37MgxQG/t5xL1fxeLr1MtlVM/ykcuCAw6UW3IwgxtM5CdOQMXBQYZ/RfXb
         UE+EosR4rujE9fqQZrYZsxXsW+jByFsUiQMhdXoFuCgl7Z3lW2ORpt0MzlkdszjeWpou
         /+EIOvGLbaFkCzUc+Zyqu3sBazKbpkM4jFOB8kkMewNPLdMbUthQq95YbEoBQBgPHPLg
         dDAzMT0qmJ5xoJn1Fylu4airsriJ9n/OLfT2AwvOx5nPtXqR8+qfICT/Oqj8I2IkW6yx
         g2yyyURPTQu4czESyKeDZiI66i8LBdTUA69sEuQc1GCMyVabzUKnpiB8ZeOl7divvaPv
         I9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771146120; x=1771750920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+D0ODJnkgxsrPA3UYy81wUrrkW2kcfyG+MPWkVZLGUk=;
        b=wBN3JzgssszvIpUATDQpoS+MjgJPh2FZ+lo3hbrw00DVKFFK4eGzw080BJVSCK1FQw
         eeMS6EMfzZG5jrERm5B0dJPBDXx1tlHgTbC+HKD6V9Q6Sx9417YqRnZeCh/g8qFa/B3z
         Jazr97HHNUY3/LRPAfu5hY0RyHk5m5XLcof0LPE2HkUIL2+VsHNnFABzgsPS2nVyiV8q
         YvVCIbF2HTIvJqExTyNZ/8ZtfbPISbZFIlaC9lEcifL5BhDuByUALxcbfXHtRoeDgHnD
         cooI4Co2hjmBCYCRhSOHE17v3JvrOicd2bBptYBKCWehAb9ac1G+5JkXHzftCuy4lMu2
         RRIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCaGqoqMWPUeRHgnWpLfmZdtEQAil4OhhnhW7fBY30/FTVx+S1cq6wYQ/DjOOwDGuecuqFxBoVkQ==@kvack.org
X-Gm-Message-State: AOJu0YzmUBC3tKin394xIEVzPDbTvcVdqtpz6r0HT4Hh3QU72ofQSf27
	STL3woTUjvJ++08RhTNoO30UsuhFT428wbYHgtZ1jpgU97vGdhVOuIJR
X-Gm-Gg: AZuq6aLDDyA9XuQRfY3r3cZR8kizn17IzS+qrxtRRYJxojdUERFenOVd6Yofw07ZXuB
	ANqU+piEgA97P+2vOHtk4e+HDtFcqdb/ssyIIozwFrCWHevsF0CTvYAmZ2X5Lto3sKSZF35NfjE
	CxRmXJBnRzBKJhNuiHAZytPluTWZ8UkVf+bla7HCPjaikKROFEI5us0Q57KucJ+G5uv/dvzKsfa
	IXi3b4NwnvVQ8TbNJ7Ip1xOCji9LuROhQ4o0JDpGlQS5QsRDeSREk/yME1miqcIvcVbMUx7b4uE
	O+Yfde1vGqixVj2AtfW1vPUZ5tH9ohOVmPZWfHgRSQ3oPvu2GjKgxvcpCi2B1Of9k2Sdhm824QL
	XKyd6+yatKWjhE1rnbwzLLy87LxmE3zvglRn1eKwNTJl1NEENh0tR1qaQxIddciqBOYWsGbk19H
	eEdsnZCm7yLvx0QkkVLGpc
X-Received: by 2002:a05:6000:2311:b0:435:a258:76e with SMTP id ffacd0b85a97d-4379793dd5emr12414131f8f.60.1771146118907;
        Sun, 15 Feb 2026 01:01:58 -0800 (PST)
Received: from localhost ([2a0d:6fc2:4b0a:db00:eb98:5335:fc91:c4bc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abd793sm18612064f8f.25.2026.02.15.01.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 01:01:58 -0800 (PST)
Date: Sun, 15 Feb 2026 11:01:57 +0200
From: Amir Goldstein <amir73il@gmail.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
	Andres Freund <andres@anarazel.de>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
	ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZGLhTvjmRVZNA8m@amir-ThinkPad-T480>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4qy9w7o7o4i5xwmxj31r4ceztez1u5ec
X-Rspamd-Queue-Id: 5F495A000B
X-Rspam-User: 
X-HE-Tag: 1771146121-208694
X-HE-Meta: U2FsdGVkX1/u2ncLVm2ImQg5mEaVR3nIaH5x52TbVHlN0kqXdqYdIIM1agECa1JHZ4s1en00HySWPqOXfgN+LQ5kQhzWOsO0vRCeNVyn6MQj9Tee3q6i9BhI10jiUlFDivdhPIBo3kf48a7xBgOEOuikR4gaUh6dy4bmGr1oOGLjVtMVTtdBgOZW/Jrcek3KXmjPIm2qxKVcCTh+Oaz3wjAhfO9oPISCcXnBV+3PsW3mB/GfZSwwhpPlTHMALPCCkVHzOLwmmHc2f6uoam4EMgv5nJZMWRhD+nXx1r8JXCeoIWVVUZpGE5gbICilAMO8YnEYLCi6+c8bHjRfOaFkBK2lS3bRPkRXxVZCYQfblIbEXMG+gvOsYmmFgSqC50vFqfjY47Z/eKHfRhH1jLcOxtNIg25OU5t2ydG68JXXIYGLav/0yucNUMnJiiGYYcdD8Mz5v7y7lGNerkby5iPpLxBBcYzE4WRq/tqzLLscdzLpGyuE+hvhVqkNg7DhXuxCwUOHuxeMcPyIOehh1fDnS+MXuhkyWIad7sgycqLZJ4D5anFzB6LiAFOoc2OXuvDt0gYKCaj6mUAyL0dM56Qco3z/b9BdYr3qGVSo5uv0Meudhyzrox0nhTrZJfG8D6KKEm8WLuPluoIBVX8pUGRP6nSeTfhz+Rh+qx5RXjJnui967dDJ8jfbnOLx1+r/Y8uPMOjGJG45MgYbEyYVS0q5e/NzDp1BHGSyToLQmNCJ30E21MQBJ3QbtxW01EbhYOizUk4onMcBDbBog4u6utssILksqG4OR6qF+Md2yl7EHHWOGIQlj0ctnVvVvM/xvuIoQ2tigMjx35LdEx6OS5pRy5RDVAcIZY+94SJ1lu/+PHp3adkYUcobyNL1J1KJkCuHKSX5+W01O2u8DVeNLyXcGbZLYXBmgnpZ4PexDKOCQqAAC2tlLr7cqym3+29mml+TPakmCW07931le27USg/
 ZlKBBTY/
 u5sSbwkRSqsMJDIayFPHcNwSIs8ecF4MzXugUMQrWp7H8+TbMtI9AyCGp6FGfIW+VhRGrw0Q9ToKgjN9ius0Dh8ugUQEMV/qFMoT15bh+aSwHIogpww1fdK7+g5+7IzQDlDE88pW1t6U6Do4zKRhg813bo5nvk+5j2p276zm+U9hi+rYAsifJC5kwcPNbtUPU5sXD46/7lNoH9dYC8IrnmSL2fhW9BAWmdg8jSdq47Ivu33WQbLx3Ti0Y3yobVbwXfFye+kzjllpeB7HuyjHvnlcTLJKxOq51AhK57rGL6sEYWMr4bh2rJFmovcneYSzNMUqE91NgRdO4GtWgHq7oUJBJbUPnEtAh4caaE3RRWqsJw+xdM6Fuur58qloJIzl/mrNNzdS7ZoLzW/wUD1DiZXdvy1Scl5fD+9E2n1twmyr7oYrUeUamQgXOwki+qtT4aZWKygAZ9a3jaTXAccgqGnFffPyv1YTwYzOVH/Q98j74aEOrgmxTLvTRVEskfxb37LJptqpfZpEnTCQJ5phCxIAOzrZOizje3D++ayHieC9/qHeyeS1I+fc0kd2+IiDcJ3wkjffZJEtoBtmjypwW2EQA1gZgYUo8jhQlnys5mOdUOWkGqeieOP6psilzd961uTq+fM8j6eB/nwStB2Lne8Ozqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> Hi all,
> 
> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> remains a contentious topic, with previous discussions often stalling due to
> concerns about complexity versus utility.
> 
> I would like to propose a session to discuss the concrete use cases for
> buffered atomic writes and if possible, talk about the outstanding
> architectural blockers blocking the current RFCs[3][4].
> 
> ## Use Case:
> 
> A recurring objection to buffered atomics is the lack of a convincing use
> case, with the argument that databases should simply migrate to direct I/O.
> We have been working with PostgreSQL developer Andres Freund, who has
> highlighted a specific architectural requirement where buffered I/O remains
> preferable in certain scenarios.
> 
> While Postgres recently started to support direct I/O, optimal performance
> requires a large, statically configured user-space buffer pool. This becomes
> problematic when running many Postgres instances on the same hardware, a
> common deployment scenario. Statically partitioning RAM for direct I/O
> caches across many instances is inefficient compared to allowing the kernel
> page cache to dynamically balance memory pressure between instances.
> 
> The other use case is using postgres as part of a larger workload on one
> instance. Using up enough memory for postgres' buffer pool to make DIO use
> viable is often not realistic, because some deployments require a lot of
> memory to cache database IO, while others need a lot of memory for
> non-database caching.
> 
> Enabling atomic writes for this buffered workload would allow Postgres to
> disable full-page writes [5]. For direct I/O, this has shown to reduce
> transaction variability; for buffered I/O, we expect similar gains,
> alongside decreased WAL bandwidth and storage costs for WAL archival. As a
> side note, for most workloads full page writes occupy  a significant portion
> of WAL volume.
> 
> Andres has agreed to attend LSFMM this year to discuss these requirements.
> 

Andres,

If you wish to attend LSFMM, please request an invite via the Google
form:

  https://forms.gle/hUgiEksr8CA1migCA

Thanks,
Amir.

