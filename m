Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1C060A2634
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ac/UXf8u
Received: by kanga.kvack.org (Postfix)
	id 7B4EA6B0643; Thu, 29 Oct 2026 14:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7650E6B0644; Thu, 29 Oct 2026 14:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D176B0645; Thu, 29 Oct 2026 14:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6826B0643
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:43:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C271DA0407
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:55 +0000 (UTC)
X-FDA: 85376538030.01.A4AF790
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 401811C000F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ac/UXf8u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793299434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RlOZ0RJnKxUgeMhyqw1L0vtv0SrDqaFrd5yVGZ9lls=;
	b=eHQr3h3CUqzMEoTpgJlHymcE64fPHFfeB7hfI6GH5/ILhsyTtXsDz2xrzqxFfJdh6zghdQ
	JSC1q1qsz7LqkW5K0rD9Bd/onlz8pTa9Y67M7YHBMaJoy0/bmxJq/JtOZ3U9UK0ps5vNvi
	eK2fp3KPm/IC45Ht2BU8JdLLlcWehRI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ac/UXf8u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793299434;
	b=rNlCFAbRPJOXXwpIdR8MSCqoVcFYn0u6Da1i+AGZLuGNovN6YR4tWuWKx3NBXhiWhIHlFj
	SeMVhXqS8Sz93g8XaRNF0DBso4Po2+eCwPZN985FDekYGCCavnloHu4pgoS8Cn1ydiqwTE
	A4WVzuAOUt1w+zybp9NYkus80/0pK+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9277043CC2;
	Thu, 29 Oct 2026 18:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B351B1F031F0;
	Thu, 29 Oct 2026 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299433;
	bh=5RlOZ0RJnKxUgeMhyqw1L0vtv0SrDqaFrd5yVGZ9lls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ac/UXf8uFBzxv2bpCCzl7qRy0rDogI1PYO88cY0CRfc7m/4oc/gb0xPzCa26OlZRh
	 7tEvn/S/wb3Y81YeeDPe/YLBl0pWmgW8BbYz5B9109czSpiS8wfunoNCZNwq9pF9KB
	 CGvJ/y3ksPu/l6nXRVeKpLkTVQu5/Dqy6wq0zR7gwqFhXilMJA1viOxfST/Ym4K2/s
	 jxA18FFm9dasRD3UEafADVEjXpJ/oHm8jO7DNPb094PPrxbeVtHVQ0+RfG9SInmBdi
	 +DPBLs+4UwYLJRyteCOrFaG03DjAkbdMdHk8o7+BFsi3k1pUTPgGUl2swgjanVbD2Z
	 8yBItAgxVoVag==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.6.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Thu, 29 Oct 2026 14:43:23 -0400
Message-ID: <2026-10-29-1-daily-reply-0016-damon-pid-leaks-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028141430.161175-1-sj@kernel.org>
References: <20261028141430.161175-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 401811C000F
X-Stat-Signature: z6eugmtu6g4119bcze4wnq8ftqm4fh6k
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793299434-156970
X-HE-Meta: U2FsdGVkX1/pAF8CM8XBP+cdr5WlNCGNG2IfoecHdEsHPTE+B8a9pWDwygpuhR7HYPVNLeoUBE51HbgZFm9Hjkt7muXTUQJp/DfWx5uRab3QOhaNPaKwbc9ANbsGqfuddRa5VTUvg0552cA4aYCpOJdVCgMMdqYyZusb/iuIxDW8gbiY50y+H+vH/vxWyeepn4oKVJQtYz8YNqg3x9+aFW7san9dYXcdry8DB6DmZVeyrpgTkPvpaGBpOTjyduOh8FGH+/nSYs7gleB7zSVs4gAPc2n8xitflrl7y4DJOMYgqrVmDfNPkARXAUjH/PESfw0uIKDqo30aIRXlhGuV3S2v75NdAgUB/wW778hyc+6YFdCenYSopQWwRuzav3qHhmZDuPpCeiziu5Y3UGOj14pqInXmHpHPzoapD0aAUxfrjgwLuP6PUKEZOSn3tihujkigqLudCOvqyKu7fAmEj5xUZYXVHctfvsOP1yJHVyC5+MqRN1vWL7C8o1GZMgNL2NCrNMEc4f40RSxCNvk1JZNoHJpeJ1rMaLdddmq9vc/07ZclCVWlAJiIBmuVUnd65+HJGtdHc/fxY+0bMTIr1EWctVkFRP7eJrzIXm6p4xiHqvry6rqEnlgEktWPJXBzYlXoG/q+PJRBcfAfywmEnVVrO0KX56T/Ea1e8fbJu1ts7YPAlkqgXIvZmQU/X8apEqRT1MZpJuIFv62yoaHxPTwHSxBMarYYB6Ui72fT+HnFZLxjHE+iamXK2IhN//JBORfsLCChxPv7oDYJkqH69qXkMC/Kw/p0SuQ8v15prKetmJnAqU6gxSMTXYIs5OmPCnUURFeMjJdUgAeLj7pfaCFX8tWJm0kf1LmOEu77e8Lrgc2hHrqPfye2H/vC62nrf6DghlhXJStg12wu0ChZPdOihSevNxU+LkBT3APhf7n3PrYbNEmORFu2Lfw/+U2wZH98eISE7DJtHsvFpCe
 tXjSJzIl
 k+AXDbp4/I3eb/Nbz20SPTl1A9j7jJZG3WsxMjG7Mb8uS3SSBQ7fken0gfQBSic4ixiFl5+D/7pwMEFfG7acRnNqaHfviPASQdzPZiMrwq6rRo4aOmwACuEL+Juelr8/1uAt0dnWOYObuQ8Djdq2N3kouxcRVYC1KlJn2VsVLRtzf53nN7MRRz4UydVXgUFyO+PqoqOWJai71uGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> DAMON sysfs interface can leak pids due to wrong error handlings.  The
> issue in the mainline has been fixed with code refactoring.

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha

