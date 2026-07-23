Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC77DC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1AD6B0160; Thu, 23 Jul 2026 05:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99046B0161; Thu, 23 Jul 2026 05:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD53E6B0162; Thu, 23 Jul 2026 05:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A477A6B0160
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:35:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DFC48041A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:35:36 +0000 (UTC)
X-FDA: 85019533872.12.3FAC888
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71D121C000E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:35:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJKTuk4Y;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784799334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZZCZ/d/c3xLlwTJG317mBGnb8THEbPIiA7jBD/2pKc=;
	b=4UYsM1teM/KlZ33K2M5E5dDXgbPHZ3gIRMGKn5ig2iS9xiKKmDKFAP4c/j+CtvcsIt5E/P
	A8B6iKa1LvI6OkZhlyF73U96hsZeYPTYec02x29c6vCqyycvRYwYK7w7id5C8xRM2t2wLz
	/kYbxCB0XEZzaWK0pKqIn3rn9RxDD6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784799334;
	b=0vZZcc4BaWlblQjzE6+MaciJKvMyt2CK9+qg497hIoVSqBJHC/sjy4EIOsPskGZY3cH/Kt
	d4exxqtBn9NDeBC6uzbDOemndu1yxfqQmE8cVcSykUumjf9dqmGkxc19UiDTdNOegPsxuG
	V5AfxaRciFMFwmKNu7uwXbAF29TCInk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJKTuk4Y;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C481B600B1;
	Thu, 23 Jul 2026 09:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B28F1F000E9;
	Thu, 23 Jul 2026 09:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784799333;
	bh=aZZCZ/d/c3xLlwTJG317mBGnb8THEbPIiA7jBD/2pKc=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=HJKTuk4Y/BNCfJUH/Scq+NVzyNgpwaaMcN7elruFMLa6kysXsv3I7IxKHDCxBPw47
	 DIuZcGDZYUIgna31G1KKOk3CIP/z9vxNh8AnE3qHOXZ/Ufk+9Rs7sBHfryT3TXEtxP
	 B3dSRJRgiLuz5y8PlT/EWwZP+gSQKGMCWiHM4N6I+yuNPS3nuRq/xxb8CPgwy/3TRc
	 8B4SOK5+OEL2aIws8L8TSCvwnXSwfi/DeYuEBBbEsiMAGRNbrn+Vw6VV7usFqaUAyz
	 7X7qUJvSKXz/m6ZICFTxewrNh+FCRQfrlFmnyX8vNjoftu6SbwibBymgEQdUuze6W1
	 FcOnthHcz5bzw==
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com, 
 dgc@kernel.org, qi.zheng@linux.dev, baolin.wang@linux.alibaba.com, 
 cgroups@vger.kernel.org, clm@fb.com, dsterba@suse.com, hannes@cmpxchg.org, 
 hughd@google.com, jack@suse.cz, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
 Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com, 
 Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
References: <20260715103516.2410175-1-usama.arif@linux.dev>
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
Message-Id: <20260723-wuseln-nachwachsen-befeuern-82f31d54fd8d@brauner>
Date: Thu, 23 Jul 2026 11:35:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=908; i=brauner@kernel.org;
 h=from:subject:message-id; bh=P1ri9jIlf5K46sMu+BdMRUHIR8r3nUqwsZr/hAYcuzA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlPkiQnrH6ltPc6U1T9m/Wnse0usZoz8KbU2fL2liV2
 BxfrXrZt6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiLtEM/zQieN+tus9Xurtw
 8eq2k9ft5mitPNCzuWpdxBxm1SV37vEwMtxc8rG3vvm1YUjMhOXBhREVpvKbmtaVHDmuHOx2KOJ
 hMT8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: sjbj939qk6ohhbiwgwmqyx99t7pxf5uj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71D121C000E
X-HE-Tag: 1784799334-952256
X-HE-Meta: U2FsdGVkX19Vjzd6ty54KxPYbTR7YsbIOpTlZYlsYiVvtdJmSx/NKzkUxcpLLUTCVhXwLADV+zWvYMBFmg67WpobZMSR68ZIpctM2jey1lGB9EQiPhH3fsZyK/gtGHp8czC2JYEhBUOElzRmXtf7lWT2HyrwsVHAJIE14kmm+V+zfUVtISwHg1+EBqcOre/NL7rD9NYxnM2Inih8F/tMv+9q7+Ry8VkQj8aMFlULfxZ1qbYD8jEZIuruUZQRjlei78/qKJ9hOWzlvuU0jHMtDC8P/CghDhkbcBtjibRM4IqsSAS3Ox+iB19ag3VwnkaAYu6444uVHXmKdxsHYBYZ40teS/1MKtBre9cOTu60lqSA1vrhL7zORE98w8A1AgCOapqwA4y8zMgsGA3F/Ewy+lpNxEpefyR9bLQAzHQSYihk6q6rtzG9mvyNNHWQR4uurkL6U5NT+87KfDcxO5tzjg1LgE7pQE6W4wffg+arLNypC9tF8mvMn1UH+8Im/eHFDXiWc8SpQ/mhnDPezr8lU8XxCv6Nt1hUrCra+oaR7Rj0w+2/AHoQjjRzxE1dUaWgWWJZ1kWILjkXRthzY7WVvDCdearYfBosCu3E5uc59l+mtXdhgoS4C40dJRvyqYzjbKwpst4dbXn1pqiH1vsN0HHspJxbVX26PKo/ke6CpC8cwITm0Ma/ACoYmhyCLTbByaVjXSt94MlxZgIK/NAybB7p1VEa+KlUG1TlvXV2CqcbzQ2KxLWRIgSLhcUp8Mwiwf/JQXQcjTXs52ifxfvsfBOvNpF4EEYNs5FpfnrD1wpPllhVjlYUXyd+7rrcpLGmyt6kzQKNYFrsgB+8J7opgwBoDGNUHF+rjdnNcX2waOXmCDPejDawcLiM2Mtg2LXool5dMLwlIfu3LGPXuAV+oX7c76RX34S6JLrIYwJlo65KCnWXklgOIhPmK8upaA7WXYSkahulDVeyiW1Dq/W
 0y2IcopR
 UD0KgPhg1tW+lJEhQVj4u75uBKXmP61nJEo5cUDYgYGQkKf3lbCEsSEFG/u8t3B/8pOqJUzvb/kswCLjQsVUmtVpnEu1zrcUIFwvcdbO90PmjsUXqnzSwIu2QM6vPhh+2CqQb9vjBiGK0oQpg0ilWcxUBK07lc2WNnzCR6JRlpa8vcH8MYdDd/C8Q2cNC66/eHUP7jXuKdDKMwseHQFptaIsEOjQQN7Q/eOiQ0vOqoKwQUW71Vjks/7Z4oCSen4RF6M0T2dTk/aVkisRP7kFl1JEqsD9b4Oy1U2MioBW6d3oFK3eH8U4fI7zHXvPA323WAjVmTOqOrATgIetznUm22AErIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 03:35:16 -0700, Usama Arif wrote:
> fs: push nr_cached_objects memcg gating into individual filesystems

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fs: push nr_cached_objects memcg gating into individual filesystems
      https://git.kernel.org/vfs/vfs/c/d5233434ecd5


