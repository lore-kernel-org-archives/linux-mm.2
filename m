Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E2DCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 07:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FE38E0003; Sun, 21 Sep 2025 03:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010448E0001; Sun, 21 Sep 2025 03:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68998E0003; Sun, 21 Sep 2025 03:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D56288E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 03:39:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D0518608E
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 07:39:54 +0000 (UTC)
X-FDA: 83912458308.03.4883C15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CF0E780009
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 07:39:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jg+I5mIS;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758440392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/5rWeuzmNLpEF8jpC0tA5WOirM9K5bDidp+4wYygw8=;
	b=z3qTueYzIH/Hu9a7TPrnLRDmqsb9AUcnwLQkVgkmhrby6+B+k3Q59lfNifXN7zgYilmZkY
	DRPP30SQpwwNrzqvDz3u3B5X4sNBv96TZ4EycnboEecq8FZ+yKDiNxrC4PkHUcIVWuE7EX
	TzNrr4F7ICm7qAf2wkD4xiNMEJ15P1c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jg+I5mIS;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758440392; a=rsa-sha256;
	cv=none;
	b=QxJKKHJGNR2QcrWukfc30nF/EUGAgtKoDjTqtA4jVGTW6GGFemwtmKpECrpvsOeaug+Ju+
	LjrUyzk5cEi+SOZFyxpzwIf5XD4Kp3/WPn7/abJC55L0zeOU6/XzyCCTK1hLAS5IVrIjDC
	dRj0s90v1SkUvL6gYkSAzieLbNsIo2Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E163D600AC;
	Sun, 21 Sep 2025 07:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF0CC4CEE7;
	Sun, 21 Sep 2025 07:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758440391;
	bh=YeDyQS3+mMpnmNaLa0DMpyp/Ge24svjN6e7TseL5PlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jg+I5mISszxOM6vxuJLUP7StToWz2ZhNXOYlCHpWWucv2FOMahAAyW9olJkCHsamN
	 rptxT2zcVb5KRr7njgD83lT1mW0XXICmlWbWIlDs9w8Kq3KCrno3ezVryu+wXrD5Ut
	 cMyPy+D+JD+TZIebBf999+FwAyKy2KNsit1+aaVs4qnz7B7dbCUeTmHf1yM3nEiyp7
	 IOOSC4jJ8ECjGy9cGQ/b3k32jrQ3Lyxc1WOE1/LaesVDBbA2qf6h5NOzHxkL1C0aVD
	 Eu7l0e46W6X6qyeLMYzsCNbNmUMng0duQKijN+C1f9MyeLyCyMSXb9nAoGUrF0bUIa
	 ZvTVD+X7Gz3qw==
Date: Sun, 21 Sep 2025 10:39:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove PMD alignment constraint in execmem_vmalloc()
Message-ID: <aM-rwfvR32xmbCXj@kernel.org>
References: <20250918093453.75676-1-dev.jain@arm.com>
 <aMvf_R4ttLibbnQ1@kernel.org>
 <d4019be7-e24c-4715-a42a-4f1fc39a9bd4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4019be7-e24c-4715-a42a-4f1fc39a9bd4@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CF0E780009
X-Stat-Signature: og8wz4rjj3qmr7fu8egucf4ys4xh844h
X-HE-Tag: 1758440392-26468
X-HE-Meta: U2FsdGVkX18/N1nJZMNUqKNGDE0VrESX++LV0/bOX9Um5/Kg+q9amhYk4UlpT9SiujQgqpDyx64QwTrvHvrQPrR5siOyFz6AegYpAQ0V0Zrzq4xnMzGXMciNiCiGDtQotbzNZewra+KlICxcBP9lCRPH25099zDcrl8ZiZzvUx1VVQzcMlo+Rsh1F/HiRdtR4+WIjQ16PvtMv5jEE+FICx6QJ7DV2IJRmd4/9+UYjO0LafgESKrBK4rhJ6jbwPrF7CDKKS0znqOd+EKs1T+vtS/MplHHItGV3hptJqhtPbXuD++fsZC8zj9Ecr495Fwx4u9JEK+m81rmcgHfGH2iZfOua5zUuvhHsYKTGWfZQ5Bp82TA0skFW1m6DoaoFIlla1B4BY4FMMADCBAl7H11RoJ7JJGcQV7UNoZjRq5VdifH2LnbjEiwJpQqO0F++mKzg+RewrpCrMb8uDPKFnjKIQLR8PX1nxfhrk9Hz2rFSn/zvQR2uscxCMXkQKJLgZymJkFvhrOPDZNlNabpwP1ZdO4+o8MUxTx9SRUvWln3MAFj3PWxCrLVdetSAQQouzCeioIg1BCsAGpGCYVdSFUFGdLyorWhanVzUJaUKEbl8vunpwzuo55f/DtsXRguJYDHDKUym6c6qeMPxwxVgB8Rv0QYN3PbGXQfDF7mQTdrpea0Qq2fD8/1Y6X2NeYFppUyplx+hA9XXuNa4DqkB5q/Yvy7Q2gmBGis7OTsHVi1prgtOEr7RWcDROniaXjn1PzkD/LoTCc4GkaIU7ZkSPTfVqJBzhS2kPk9BbdNZUjNa6xJY6Vg/EKB8tAbpP+Bx8J8fQUPnTW/5f7Xth4O6KN6IWq7A91V9Q1o/hbfrmt0r5Ol4f6NdfJ7QDMjf/WUbNdVFmkNyNOO5FYYYN713IzBvgsGLO180Wlg/KddrmZ8Ykm9773VlLIINk3juf4+UxWq8M84VpWBmjw/1R+8MRz
 U/F+pD2+
 0Bzb4bAF7CfKXQ0wA2SarwbbiTTCVL+/VVmd9FRa6wgAqmEuvpsYE0l7M5bueIoFL/NhM62SiSm1cEHEc6BkitIExVmqKIjZffKRxiHt/t9gh+jf0AGNCOZCsQzKFwALBfsc5T3M/o/P7+snes1XF7rs34oqkc0FqqvQov1+p2m11TdWJkQ/0i7+HGbFJPP7TlkE45fvRQHxA7G3NEzWu+hER9qmtqcjU6Gi0jxJXA3chM9IyktPCu7EcoL5si7QC+kgDYELXdByy4vybfi6VwK6lksIGgvZCpqBJotf2WcTa8xoOP9lxl0CtRdibvDtpAUpKsmEV83kLjsMt1n1xuItizLwtgPKMXtJ4K68oqDcHziHdX0EFZiEmXhXiX9YSd2oY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

On Thu, Sep 18, 2025 at 02:06:25PM +0100, Ryan Roberts wrote:
> On 18/09/2025 11:33, Mike Rapoport wrote:
> > On Thu, Sep 18, 2025 at 03:04:53PM +0530, Dev Jain wrote:
> >> When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
> >> to PMD_SIZE internally, if it deems huge mappings to be eligible.
> >> Therefore, setting the alignment in execmem_vmalloc is redundant. Apart
> >> from this, it also reduces the probability of allocation in case vmalloc
> >> fails to allocate hugepages - in the fallback case, vmalloc tries to use
> >> the original alignment and allocate basepages, which unfortunately will
> >> again be PMD_SIZE passed over from execmem_vmalloc, thus constraining
> >> the search for a free space in vmalloc region.
> >>
> >> Therefore, remove this constraint.
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> > 
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Hijacking this thread to ask Mike a related question, which I noticed during
> code review...

Replied on the related thread :)
https://lore.kernel.org/all/aM-rDD-TRqmtr6Nb@kernel.org/

-- 
Sincerely yours,
Mike.

