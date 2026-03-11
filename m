Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104D1FD88D5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD266B0088; Tue, 10 Mar 2026 21:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AA96B0089; Tue, 10 Mar 2026 21:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65E36B008A; Tue, 10 Mar 2026 21:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B50126B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:18:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BE525904A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:18:31 +0000 (UTC)
X-FDA: 84532022022.25.3F0EE5F
Received: from mail3-166.sinamail.sina.com.cn (mail3-166.sinamail.sina.com.cn [202.108.3.166])
	by imf11.hostedemail.com (Postfix) with ESMTP id 196E740005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:18:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=YsDgzFEV;
	spf=pass (imf11.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773191909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChXyyqStyHvRMmaOsnZNTY2iWxfjhqEzfA54ZsC3T6g=;
	b=FUxDOZ37Q5JJ01US8PbxbaYkTHA2rgnL5wOcszb9MccZias3D1ZEAXrNgVlfYmTwRSu9lg
	m/IGqFIWLG/a+4qQR86wrNgb9ijuAcaZ9gIzM67x90E0mCzAOXHLGm9BlPIqRnjudUs1nE
	Wo85UHaq4lpnZVIqt7265u54OzWTRbg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=YsDgzFEV;
	spf=pass (imf11.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773191909; a=rsa-sha256;
	cv=none;
	b=ZrZfW+9mdK/YcMTe3mGW9TYuQTzNFhO472jpUf5nUROpcpSfHoslpEd+wgN5fUqINu09bb
	sgDoH0vvJeCKR4bN2eQ4CF9LjErsTAP4+5DiqqeMMh+9z90G8uRxoZW+auV0USOmHggk/n
	Lq6cxMiL1NFur8bL5GHRjeYSz69swIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1773191908;
	bh=ChXyyqStyHvRMmaOsnZNTY2iWxfjhqEzfA54ZsC3T6g=;
	h=From:Subject:Date:Message-ID;
	b=YsDgzFEVUpcRZQSJ+TAuFPDEt0l8b3xDEwrkvI7UQ+7OzetJhHIuOvIKmWOoh3oxM
	 2Z42qkj5JKrglx83RRulgbgV0yOfdxpVcd6Qir8ayi1HQKLgBjKhNySDHmjEw+8Tx/
	 FLWCEg5hmxXOe2B4uZ8Fdmzk2C94A7kSYGbDXBGU=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.31) with ESMTP
	id 69B0C2DD00007CB8; Wed, 11 Mar 2026 09:18:22 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 9687306816499
X-SMAIL-UIID: 7E0815E5776D42F09DEB167BE80166DC-20260311-091822-1
From: Hillf Danton <hdanton@sina.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Date: Wed, 11 Mar 2026 09:18:14 +0800
Message-ID: <20260311011815.785-1-hdanton@sina.com>
In-Reply-To: <abBQ40Zkk76Zej8i@tpad>
References: <20260302154945.143996316@redhat.com> <aam1cHq3_fb-T1HH@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 196E740005
X-Stat-Signature: nx9t8egpjkmhougn8err4q9agzegtndz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773191907-399908
X-HE-Meta: U2FsdGVkX1/LJE++bjRm2PEO4K76/IAXOrmhEl01rjVcffu+CgdCjSgmZHhkjaZOcNoTcwjuk9mhQWNYmbr7p0i19BJem/neUWTKkrZeZxb1V7ZKsA5o8qyaIeiH6XaGuSBMb/3PNg7XFudFZpXO/CLbnNsrYGTo9my/dbydg7MkqYH7imODJv297p09nOUTrrrRTcRSrSF81Sdv+R4MAVn9wBCDJ8LCTEtgTyVXOblfToT2+M5iM2fIx6y2gSRDZmgnwwk9XvoFyy9JB3G136uMdf+RFRQKflKHmG/YSmbKOtM3pUIXAU0m2TIHdeWACoW62w/HS5rp5MdQxxtdu+XzTFJeDjw3HWU0MMkYzKkKrydbfN6YbJ0yCFn3R2DYsb1s0VUZT8W/7BeMANCOZ4/VvyQxsjHvxfeR39q4I1I8tYlisgk05By6BHLsX1XIfyw3wpRlmRPBBtSXrCoOfnhIDg9bvUXlviInEpMOJNv1tsJ5pcGqkAUdVJbqft2nSvBgKGScQS7pVOd5fNAQG8xUuswiQZuK6TOaRMyAf9sHTj03D1zYTyQwkyl1TCWLzVIB2pf33urkt3Ja0+G4tyLhU4INydYZcFrmWY1b7X0Z2mgQyEVsVytL5LL5x+SkLMy+NpxOqG3iRSWNw3luHcTVeDRfJn2YHzqXTZS/DxjGwYGAOl/UTlTcOq/NHlLU/yy4ixUEZhR3UxznZ/5DengtAHhIHy8sO1wGGfz8o6dLpnPN8nNiNBwbAneiybraMuLbKXWITQmwZ19Bw3aCmgh7QG+OXazkxYuLP8ngqJmGQMwmQ/dcskfPkFUe+c+jvwyPuQ9H9IUHp8qmnKUPltLDT/emd8VI0lt6UhV+J7Tsc3Nnr/6znt4v4yn7TDaUr56dTJOdiv67JXDWQEEuJFvQAUXPXhOTzYVkYj4DxDfVOWX/Bya5UXTKEns4i8E02hWw69jCljjIOZMZM/4
 2tKm6Low
 M6FI+pSrPDwaa9SaP3BYfr8crW0vH8v8umWkkbWjJc7WiC9A5lEQgAfQAgG76u5rUcXNwRBz6CbKUk5nolO1KmPuPx1s02GsUfkJQVlb+iRB0mD1gvZM8lo8Wkax7FQWNbS0yTOkvRlkjlIFEruJVodxcPryOKNtgZV6EYaIqaKODvw8BOF3ZUerzMK/bEX5Cr8Mze0X7fh3ksPXozLaZ7elw1RIFM/nPoseD4hiHoje7ndsUWX94jI7djjNinV214jbrwo/MXic9Ca0R1oJO7M0Ebg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 14:12:03 -0300 Marcelo Tosatti wrote:
> Can you please be more verbose, mindful of lesser cognitive powers ? :-) 
> 
> Note: i also dislike the added layers (and multiple cases) QPW adds.
> 
> But there is precedence with local locks...
> 
> Code would be less complex in case spinlocks were added:
> 
> 01b44456a7aa7c3b24fa9db7d1714b208b8ef3d8 mm/page_alloc: replace local_lock with normal spinlock
> 4b23a68f953628eb4e4b7fe1294ebf93d4b8ceee mm/page_alloc: protect PCP lists with a spinlock
> 
> But people seem to reject that in the basis of performance degradation.
>
Given pcp_spin_lock() cut in 0f21b911011f ("mm/page_alloc: simplify and cleanup
pcp locking"), spin lock works because of trylock and fallback, so it is a special
case instead of a generic boilerplate to follow.

