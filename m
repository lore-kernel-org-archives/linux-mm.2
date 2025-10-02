Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3050CCD182
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68288E000A; Thu,  2 Oct 2025 13:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40288E0001; Thu,  2 Oct 2025 13:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CB78E000A; Thu,  2 Oct 2025 13:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B21578E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:43:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E2EDBA14C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:43:51 +0000 (UTC)
X-FDA: 83953897062.16.3F3A67E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C19EE18000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:43:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3wLJxkG;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759427029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lalhYeH0/i3XXRZMbQChSF6SzMjxEPThm2YHkBj11eY=;
	b=mYwD8r84jg4M8qSgvaRk2LMmEHRLYpejIFzvbVJ2vvS4S0Out4vX2x87wLaMGa6TmEhJAJ
	In9XUsI8PqIZkXfiUyu3kRLnlezziFWU0xDGBOAH59LIgjzFdcvqfqjGDUuMS7X0ucwpLs
	4NIVzdTCcIw2Xix/RkSgc1VBwgOeqPg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3wLJxkG;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759427029; a=rsa-sha256;
	cv=none;
	b=3IrngpzT3O8uGXUOoHXXUsTTgvYyiSpJm3soFbSWONoNkR2kURhhFa8fjaBOb3uRf0WvNG
	aXoDDt/sGG+EJ1YG1zrvZgLV1JCBMDNLMoUJd1oPQp1VLbkTe/Jqg3hbE6PmTKU0oPyXwI
	bxayFEwgSvMXP4fwIESbHo7AGHItXjg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E03DB601FD;
	Thu,  2 Oct 2025 17:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FFAC4CEF5;
	Thu,  2 Oct 2025 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759427028;
	bh=ZZ8PWqi6cNje4lj3U2qSrTAVGZuCb8id8xvf5O0tM38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3wLJxkGI6ANEihThS37BGeLsyUU7xCe+x0PnrtQJywurVoGVOqnvhPDXg5wpmtf3
	 sN1brSBoA3jHnSHeX1JmyTeu/gx/4b9rs78oMI979cGBVYaxigUlVZRJJ1Uc5jwDNu
	 tUmU3Gj5RyUc1niSe8x2RaZ+c9Q0b92rBT1WxQa5LxNXP2eQlUSIBGV+Nc9f/CRlzQ
	 8Nz+4CUEdP+6WhgxKGNZpO3WRLV4FNM9fIt2SDMfz7Ixorbjalpvs7eJbQs1t30Hau
	 hBR2C5oQLTSr7rKDbut9IC3RaE3eTg56ua4NN5+NWLU7Mm4Vhr27WRFfcwdKrFT+0K
	 uBNYki/jmbFBA==
From: SeongJae Park <sj@kernel.org>
To: Jakub Acs <acsjakub@amazon.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@redhat.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: redefine VM_* flag constants with BIT()
Date: Thu,  2 Oct 2025 10:43:44 -0700
Message-Id: <20251002174345.58777-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251002075202.11306-1-acsjakub@amazon.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C19EE18000C
X-Stat-Signature: 1s4wwey4hdmftet47b5dtaqa6495tgna
X-HE-Tag: 1759427029-449307
X-HE-Meta: U2FsdGVkX18c1Q6lekRgpZNQlI2MFqyTY0NqO2Q28hK/NolHf/CHVla/98ks9G5isNLIg96yYDDu57nWC+nXo9rmnQWxJiA/UBYMjLWpaY5y5gKt9zuZJEKRTkbp9sat1gOEui5KpkMUDafpV2ldE97Cssv0Wmber7NiLJJo/2eDTfk4OGyf+95tmfsj2q8C4b2eeSR267QPPKc4CbCQzpXm6OIG0sCaGwckcBDupvokw4esN0qtu7MYCXUlXXQ+BD0iyX2fj3JmQ6lIcb3GkwJweUAesND4rt4YzXtiNzvLnDhs1DjruPx5KEfUERw+XlDqOqgjhjujtPVfl4Nbl92sT0isN9k9VvhA4RV9u4JRfg964HzmFP6UyZ96H1HK2YlhSfMMGVplo89NW5F805oTWLY3pSaVdsi7jdJrbF1i7vStJ5YJwE4B30Y5v+KWtztzHeTHA2f/Qqq1hybUHdEBYQ37XQzhZ4piqwR1+j6NWaC3ozxi7HoSRojVE12pElR6iqXH5X8j6WyOUxBJCd1HgyQa+TNTRRjXuH8S3IA6LElXkMe4Hd1I0h2AXPqj1SUPSERIW37WeiVW8TTownFFAWW8SezWTW5sFIzKxM48loBxolhrB0ZT+Wh+e8yDt/oihh9Wf9JxkU/Xc452+UoGhaoFTov5gd2L4tb0QKSLSYv4uFNfAnMM/1ucQmWMLV9EiFmSNa5OdomJ6wT+aY4Iu6O9Fh5tK9lM0zTiuypgVgUFAC9+1LC6UoVn90s0EWloMpuqZw21isxNoiBGFh7tQHsz658g19LFxIdsHHZQJR9g0GO0P7YLMtdw14oOSz0+/ewIvqv6QP2OCg6kzlJ17jS/9NK8iQ8GDbmmS3P/XkY+GScn0ZiQKbcHhK+pfoS/kszKHQ6noNCovrVk5FV1jkfUo1HmvKtshGEDsLyVDd8N4fMbt9DysOlE4kj7QQxVqn5E/8U/grP3Btv
 j/xflZki
 z3DCDdIvaDW9Thw3pDbxEGN3AbqzYxKwOTvLuM18kh9Q+vrGj3fA2TiHXgQcTr/U3XTUFRBgSarMiTSLPAaUqChTQ9rCQUVgqLZC8+7P4N26b+9ybf5nAgxWWcPdUztImERh42yeDjJjl532H3zBrDMGvZcEmEnbwLn1+xzMNgBuyktSTOaDoWu58iVeX746BR2iGdo1cVfM8uOvkRTalKF79DuQN1ITseGGl1t8TKVeNEinKmdY2o/AtKSGj+7IFZ6+ME149ZYMLFFVJt4duY3UAHXIvxYllumbcElYFMSGG9Sg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Oct 2025 07:52:02 +0000 Jakub Acs <acsjakub@amazon.de> wrote:

> Make VM_* flag constant definitions consistent - unify all to use BIT()
> macro.
> 
> We have previously changed VM_MERGEABLE in a separate bugfix. This is a
> follow-up to make all the VM_* flag constant definitions consistent, as
> suggested by David in [1].
> 
> [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
> 
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

