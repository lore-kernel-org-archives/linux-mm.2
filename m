Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC1C8FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 11:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638826B0099; Thu, 30 Apr 2026 07:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F766B009B; Thu, 30 Apr 2026 07:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525766B009D; Thu, 30 Apr 2026 07:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 407AD6B0099
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:38:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E85BBC0372
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:38:08 +0000 (UTC)
X-FDA: 84715023456.18.0D870FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07F20140010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:38:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fqsPm/rK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777549087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VImvNkLnmKjIPFDRdC1LUC9wjAT1Asb3g0SlBW6myr4=;
	b=Vdw5eRQMvavIh/3wMnqcRRWXw9keIyIzsV9nlL4shSC8awvfsXwejjab2uK+nuZo02SfzW
	PuF+cVXF7eV47tu4yczs46zo/+6H74dNjRHb+0IKvemLhAX5exZXT15JHYnQZI/GWUESOK
	3tH4Qbrb937DBNgwcghNZ98Mi3jiYZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777549087; a=rsa-sha256;
	cv=none;
	b=XQ/ySuwczRn4+anl/alD+MhQrINmcvcTJT9e/gDGLT8GWhXGSMoCh2v6LY+bpj3XPAWu8I
	9ii9LSwKtcS7V6bODYCk/PFj1ztp2RnOcq+nvc3YOraaS37s++u4TIwZrzDFwwcfSLx6zk
	l+XtStqTouMAIDHgXuCdP3+JoQrs4mE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fqsPm/rK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 172EA406FC;
	Thu, 30 Apr 2026 11:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D60C2BCB4;
	Thu, 30 Apr 2026 11:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777549086;
	bh=pdTtFTvRthhjTyLnstPF8Gjyp9WZtjRHT+8bsADDfQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fqsPm/rKBAqvXQoV32YglHso24WGilNTSccNOexAFSTCJarqJCupiBRZa2mEA5Oam
	 G3huydp2vrKXxy5YNxNXVScLV2HeUjKZjnz/7oBdOSrR3YDh4LnR0o5YzrmHJa4bCM
	 MqjbDHn2ravvfE4EfTb4Q3jDiW9Ie8wVRuwUV40X3byWEYCzgs8UUPzEoelSVZxh2b
	 wnTM0jjLDkpJ5ceSM6H72sOdUG/FN2MZU5uP3yhocis7BoCie8xKKg5ty+AgYBdegn
	 8TsaY133uEBqX08D1YKHMxaIAm4Zqb68wTsB9dtC6froCE79VuefMzN6ZZDFGAPKVa
	 ZakioZ4idttnQ==
Message-ID: <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
Date: Thu, 30 Apr 2026 13:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260430113512.115938-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260430113512.115938-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07F20140010
X-Stat-Signature: orhwy1imohkwrkgfnwmt9c67hu31fubh
X-Rspam-User: 
X-HE-Tag: 1777549086-694233
X-HE-Meta: U2FsdGVkX1+WcVl30aEQXgYtEUON50FvqI9cnJ+hVPnQEn+YLg6uovYC0b8uFYfM+4otdDyh2aBWE+jUGUXUUeg0oY2ESPwT0gzZ2z67aT9Paszdi8L245mAChC3oRi373zFveA6+FpO6/VH9AOlfjSqr3tlu4T/MjF0YQgs0NhrKR2SE0cd7RCFd8l3fBFGZyd260OwGV7L3CYJrpUaTzygQzApAI4HHKgz4m3PikmK0cvIldq+urAgz3gnUeJ5G8RR11nUA1zQRXjQp1v7F+c4KTA+VH8KEcdiZYIIjzKuTN6Ta3w+hudHV/La0RrMKri/9icS5Ej6TRL/6pMu9bBiD+Lbydu7RCIFc1Fdkzmi2zpMLJueAbL1RVSCk3Ru+HfS597jWQcDbUHmT3HBwfXns95eqVZNjcIQYUSVw2w9LFNFfBMHqOi8og+9OBkwH7jVWygEIDgBVO5ME8coXT4DDstpCG/3OLcinnUudECmsGYrrdZZgIpeRMZXSEWftS6y0RBB0MT+ZqPZrWiFCwynecGb0Pn+m0HHJHj4axpju0rTA9n7Db+Y3FKxIohvFGo0fDnvLbd9DocTQRm4mSnw0aBKVV5DCmxobkVDOoDivGLHAx3ku3qFGWT46zIFSD/osTFEoHntaGiMnqDXatUVU64rDq4gjc5jrsMQNYjPjUN9HBcB78sl5WWAwDd4Iul8TDWyQE+j2mJtq2zfcMg2F3OEmHiv7cHVzu/+5ofA7eE69sg/8CrOyjKLakZgf7FLNUlc2Q4fTDjSSUG0pYu7v3tdzTyXXu7zeV3Vj/eI063qdtt/gHiwyYC2UzDRV8gI97ASsccT9B280xdd+vqURC68c3tb0hvubFqhg/+Wd3Q94k72exWOSDowYIHIPahtbaFLugeqQAxsyU/C389NRUiBebBEGU2nd4BhyyofpExzCwgSA08xGKlBsipwr03UscMQAJU0P/Sxwf6
 zb1/Q9YD
 CLt2Rcgk6lyRnAvdpiw74nKOS4WTlLAtzaDzc/r8zomtBIeX5FRPCwmUto+J5TAVK78XEEc+IDcXMKR6UURXvPrawXnHOABp5CoH/319CeujzyzAzW9nsByPEQEkahRfeqPARcTAA/OBAzxE2MBkFm6oNmNxIbq3gTCmPPda4erJ1VtaTLw5AASoJap9E4lWIZOn9929HgkjNNptUvvIM5ifA/3E/NYPR618IW1SFv8kujuc1iySfmbM/9935jIro3Tf6zyZSDwlIYIf4X0hnq2NW8aJePeuijFlSt9wKHAMrAvlqU/rkqAJzsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 13:35, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
> functions used only inside mm/userfaultfd.c static.

Yeah, makes sense to me!

-- 
Cheers,

David

