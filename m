Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E26CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCBE6B00A9; Fri, 26 Jun 2026 04:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D2D6B00AA; Fri, 26 Jun 2026 04:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C4D6B00AB; Fri, 26 Jun 2026 04:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F90F6B00A9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:21:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC6D6120381
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:31 +0000 (UTC)
X-FDA: 84921369582.12.1CF02A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1CD4D18000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TplBEdU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462090;
	b=QEZOeFeyLeV1TmWnNhSyH1MYn9TIdlmDSJEs9lUF3QbQSdRs3K1HEFPlb1ciammN01KwOb
	nnSLOV6JxOf2j66ZpAVe2QR4TO5dBqfDj8om/IxTPoK1bGgK0o2xhz2qLf/apWZU/EL0Lt
	0vM4B54N11yWJAqmQ783R75E7W3AZc0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keBQ1PB9E9ulKt7uMx/nDlIJ5ohwmy4K2SVXnXfXhTo=;
	b=f59YuyQzaDNrvJpFtnhy7460OfULrM50g0itUhxzfEfXKsFrEfHlZgiGPxjavT8uihdIXX
	zoqpQnzTycWnbL0lz1HMKeHoS0bfKAcu09WruvhdaKijMxNipB0+OXaaZt4kRHH/qFOSsL
	UB/w1L+POyQN+LPpDKW2HtJiPbpP1Io=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TplBEdU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B7860229;
	Fri, 26 Jun 2026 08:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D0F1F000E9;
	Fri, 26 Jun 2026 08:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462089;
	bh=keBQ1PB9E9ulKt7uMx/nDlIJ5ohwmy4K2SVXnXfXhTo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TplBEdU4A/z/qEhUSGn77hXstHEYmJOXCCuN+UkQKeu1/I9KO0Qz+9fznYYYSxVbt
	 dEAkmVaUPl8uqq97GQ/QBYwsoc0KXBtQgIVRDSYX/BmQNjUqy58m/JzNQhPXP76cbH
	 796cf9T9XiQ2YthX//6M6kR5Jr/1DPvD/uF3QDIJADTCir7yryOiUIqr5YUUx2BjPK
	 rvUwIDrGMOB+2M+QznofiRmp9MYhl1iLrv41oa8p2m3DTiKv9PvMLlh8ejFDHpLNcB
	 rrMyEjK3cKyesdAwr/ZAIB8POB86Ebs36xbPg+VMubfbzyEUyPcu+wH7WOhXQQF2f0
	 BKzdbh/NP1Frg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9393539389E8;
	Fri, 26 Jun 2026 08:21:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd()
 and vmemmap_check_pmd()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <178246207624.3816447.4177031772329695086.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jun 2026 08:21:16 +0000
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
In-Reply-To: <20260404122105.3989557-1-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: linux-riscv@lists.infradead.org, catalin.marinas@arm.com, will@kernel.org,
 chenhuacai@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, davem@davemloft.net, andreas@gaisler.com,
 akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org,
 muchun.song@linux.dev, kernel@xen0n.name, alex@ghiti.fr, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ryan.roberts@arm.com,
 kevin.brodsky@arm.com, dev.jain@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ptesarik@suse.com,
 vishal.moola@gmail.com, junhui.liu@pigmoral.tech, austin.kim@lge.com,
 chengkaitao@kylinos.cn, willy@infradead.org, alexs@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CD4D18000B
X-Stat-Signature: m4hj8kii474k5jm515fu3dnwe5tfgrfc
X-HE-Tag: 1782462089-688314
X-HE-Meta: U2FsdGVkX1+T8t9/MLLEh7WXJbmbl4A2rCfjYcbv+vo2lo6HLT0mAXkMBLdFC/B69rtXaEer8PG2l5gZVIJHP12qxX577VRLipZeaif2oOVpdjFqQgJ00Bdw8i2w1vTpYE3CgjzA9esolrY+JV1WNkk3UJs3UBx6D4XhoVdbHjsAm3FMVqpm/oTlNQ6rGcLEbQhNI0FtwgYR70fwKy5C936h2tX/+U4fA4jcg+tVfFMN5Q6tBCBJdSdlx9rHdjgtVhJacTs7ubsKQsf7yuSvDJDh4o/bmaiGnBp9ug+a1Qt/bLySDGftyQ+psk24ZSAQ9o7kYcnBxMdYUK4/EugQl6iVPYiYwnQd5d9a0z/z9MlXZFjDqiyfHZsaMcx6wea3x2Nz1mcfRFEx96tp8uKOP+I7qCiooC6PGD49UCLdmUZLxkVytFsPff8vMIJR+BQ3SskxuWKdXjr+lcoW/F5vN+WA6OuLSKk4Di4p/B82r4J1BTfqi778EVPsSQdtdWEOCwPQmYRKrrNvm17hF1jxtD/HF/aY/p6+s9/RFQvJxu+cnWqxQCkdwlaZXaooL51rmc8G9wPoDJosGctvwF+KYnoL0kYecdrxLscTWXz6w3EAEZXMliFKpAdVT8xmyMgjZuxZB8SrWoYy64QbjIbK7hXIwuGw3bcKX33BO8+NKmiHTCAjutdETcx4ecR9PH8pnvwuwyx9Me1Xcl8N8QRm7kwailZSU+Hh53KY5/u8E7sXqmewKnK5HtCYT0icM/RXKG5xlq+QxFeYKtffDL1RjQvCT9+F8ugeid811wlkr2Gx/ngYaTOBKB8i2mpeY/RkxQJZes9BUqKI7d7AjXWh4N6q6GPeYy4OL+TPZXIRGmrZUEoRHqA3cagZLo6VHutDej1/hav60wmeVzqYPnH2aRz8afQkhfbt+vvdO1oCTc8DI7fMX8cj0+ZYp23R1fr8RhD9Xvos1ofd9q1N+sY
 h+7KbYEP
 +L5A2Q0qIVi5fR98vHphIxvhKemCZi9qmvWDa6JceY/4QXjkvFVXojNt9WvcmPLeQEvOXVk77BUmbGe+16Xa4E3EKvj/pKQ8puaEXhnqNviaY9Eu12K8ysFaOSgL8ap3C1dg2AFrHol+ttNd3sXS7vxIbhdir6tzjQzygSEgqYVWEOQdHK+wePg4ysR0WxJ9OE4JwrbyxuwDlsPaE/KhMv2+zwFXUNJI2cx2cLGxqiQTVVuB+BdJdsCQKaTxCNfJEpwK6DRpFsT2rysliDft6AcXAKCHa+D9JsuGwp2cKaEBRQqrrTWmHYfFfaPXxqb2iyzA6bgqItEcwiN5Dl3C2wstgcN34VO1ymivSLCtajgVVZ1yu+S8rsf8ai41mjebKzH+/BDeKQsRKFm0FuopMCB9icPmh7vGxGjP/DChyf3mNkKUd3nPFKgPcekpYQdJg0xLqxzQF4jp+AuavvyTWmIraL6wovFTQaRSOP/2ng5VcVHgHCu27iqKG2A7k66mCJFMtNZvQuWmwnyiSziCrR7/Dykm9Wnvg8/bmCwF/xfT7OKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Sat,  4 Apr 2026 20:20:53 +0800 you wrote:
> The two weak functions vmemmap_set_pmd() and vmemmap_check_pmd() are
> currently no-ops on every architecture, forcing each platform that needs
> them to duplicate the same handful of lines. Provide a generic implementation:
> 
> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> 
> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>   then calls the existing vmemmap_verify() helper.
> 
> [...]

Here is the summary with links:
  - [v2,3/5] riscv/mm: drop vmemmap_pmd helpers and use generic code
    https://git.kernel.org/riscv/c/abff0ecf7602

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



