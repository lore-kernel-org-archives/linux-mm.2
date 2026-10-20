Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5675A606D55D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6928B6B0172; Tue, 20 Oct 2026 12:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642CB6B0173; Tue, 20 Oct 2026 12:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F526B0174; Tue, 20 Oct 2026 12:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF196B0172
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:47:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48FF7802C6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:47:26 +0000 (UTC)
X-FDA: 85343585292.18.BEE5685
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 168612000D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:47:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792514844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Mz6UVuX23RzMK9sBDnIfn0n/9lxOQ67gJKXIYwI0FA=;
	b=FFIcLxnxueIFLMBofah6ronjPMSyeEPkQP4h9wJE1Bear2clxy/Sxjgu0JKhMyil6QFCWw
	SJe6dyAFLqvuMpDKmKWM46Q2ubKTOO370o20X4F6QMTjKJAX3n9yiie/ZFDsNm/eFc8oiY
	RypD1F6X7/GJ/GQdx8YHKx4lHhdcHyA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792514844;
	b=3g7oDJfepQXIyqOVZ4nKVpwNWwVEO2XC6u5KhDpIvyUeokjZTz/5CRNE+zY409qwzy7oT5
	VLzha+GWzcIjTH2LJGGfbqREeDBJ/q024xOvfgXnVIH7uZWWzFwWF6HFlm7darWg2RVCZ4
	+21uYn1ZPtZh6Io/kBy6rNI/A0HMJU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA8784061E;
	Tue, 20 Oct 2026 16:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3811F000C9;
	Tue, 20 Oct 2026 16:47:21 +0000 (UTC)
Date: Tue, 20 Oct 2026 17:46:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: shaos <shawnq1@163.com>, Kiryl Shutsemau <kas@kernel.org>, 
	akpm@linux-foundation.org, Peter Xu <peterx@redhat.com>, Liam Howlett <liam@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: mremap merge clears RWP state from an untouched
 neighbor
Message-ID: <atea2DbZ-LVi5OUq@gremlin>
References: <20261020110748.959870-1-shawnq1@163.com>
 <ateYC2eXPHuy3HK1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ateYC2eXPHuy3HK1@kernel.org>
X-Rspamd-Queue-Id: 168612000D
X-Stat-Signature: 5wbiy6xceesobod43kjr1mx4mxa8bhw9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792514844-414840
X-HE-Meta: U2FsdGVkX185fUDA4F0/ytgYoTceT01y+NICTokv8NJP+VSb5ZwJWfIxq2MeQ8waRfeF9qSVo2xTBQSbPSWlEtx9/MQrWCU0GuXn7y+rPbRyqlX84rGqXy8U9zebLwcWzb+OApYBfYU+1pJyChhaXLUhq4WysYFdeWviZEmaXdY6onZeGirxL3vndxwdKNCm8NaIRtFI+chE3Jo6QY2tD9gZJUwXvwZnGnjZEPsZET6Kms1zzr6LRISm/pIqf12ey3MsNrIQSFxCwuNAt9xqBmiHWK83Rukwh3JtQI1vDMy0R2bTHsiXm4U811MA+z6Wn7dgSj6LC8ajdVfpgulQeS8E3xDHe8u08bAq88R5SkSc6v2byMIXIjuoCMeW08R2RMgfW5HjbAuj1LFhdy4K6PXtNCqg5hdhAjAe/0AhGz01dWUa+a+yORsyG29qGRx9dzBhfQx2Xau4bIVLgJYZwXPLFTkE6dV7sa91qAkBTH3f/K1inPeKniNMW8/bLUOUqMY/v62IlfMJiGSWzEzNl0xKPKuLaMEhek00Rc1EBxgSLhMJOl8JwjGcUbmFACmhHiKEmz98dpRsvNETedPh45aYEGOJA0ZfEOtfxMKh6cXknuajhSCbIwZ+QtN5nMIHMSPW0jM40IEvQKwxaFpiYZ7faQXj+Bgyr4Bp77J/mE1jgyEL+tl5P2PcpbCQlXOPQ9UQCwndewtLGFHcNP+XlhAkFQg393jKfYwsLXrEsRJ4AhjzT8qSN5DbXkP5HUlR2IiuFEo6GFFN55wb3dKEu2XshWfB41l1RGGumKZN54nmMZQnDVIpJHH6P+TZpYCjqMsyvlzJhYeHtl8uhBBIHv9b/ta2fMt2BCIDGCl//ysveqDsk8huSt2Mtslq49jJiNfEHPFTPkbprGwNmmo6+znlhuTU0ezoizKbDzK28EAzZUJ4T+QgHUeY7CYFw7pFR4CCJNytAGsJKiSfW8E
 0pi+kwRG
 Mq1EJ1NfttwIDF30L+Z8oVhRcd6IaaYbcQqMf5HMZQQZakbPeM2AXb/PsXBjEbp3rcowglAvLzk4ptMXmreE5sj9zFIIi4vXs3pHVcRI/MembYEZyxSF8RKK6Z4bgOMCplx965r3YCzqzxdgdArjPRq344ofPFejJk/S57mui3M8GGYtZWIVdpTFi0Rjm/lwCyUys
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 07:34:19PM +0300, Mike Rapoport wrote:
> (adding Kiryl)

Fix patch is at https://lore.kernel.org/linux-mm/20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org/

--
Cheers, Lorenzo

