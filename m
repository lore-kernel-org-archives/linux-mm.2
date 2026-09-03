Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309DFC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D5B6B00C3; Wed,  2 Sep 2026 22:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754A46B00E8; Wed,  2 Sep 2026 22:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692526B00EA; Wed,  2 Sep 2026 22:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0136B00C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:01:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A4BA1C2006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:01:12 +0000 (UTC)
X-FDA: 85170798384.17.8DBCCB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 83CA940007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:01:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdCw1raw;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788400870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0Uo4/9GjDR1PWmc347ih4GSH/zQlJOODlxRby8Goqo=;
	b=DuFnhRXCnQM0QugU/CXZvAeZdPR0AZniguyM+VbSc+73gaSu3eXmx2OKJHx5YIzcCfU5J6
	98DI7O63Nz/t3NqVzf6QwZ3+KthSJv8LNO3DrCy3Q2MOnHRQctzeBNIZrL9nXtDGE/34G1
	FIv7OhhRg5te8mfVxXB1tmP8uOOLgkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788400870;
	b=mWD/WJ3QbzAvepFN4ZZ3dcDolfjPqh0AoRsojfEw+gZGxJgU1BkCAglzx0MRPMBSINTxfQ
	TTqxjnFXlSr7hlrYcRw4yyuYg1jEImzaPPcIy1weD3PaAamYFwhwZQdp+ppzgo+LqslCdV
	Pr14HT8v14hJ+tSwaFlU7n+pRtKpT2g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdCw1raw;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C2F7600D4;
	Thu,  3 Sep 2026 02:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DB01F000E9;
	Thu,  3 Sep 2026 02:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788400869;
	bh=R0Uo4/9GjDR1PWmc347ih4GSH/zQlJOODlxRby8Goqo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=IdCw1rawiRYc0trHWoNkiCpk/zJK4F75lPjA7InyzfRmdpSHE2q59RawIpPhsXm/D
	 fommiBLrqcyXLFZo0dhOBctX8YrlG6zpg7wNQYuiWDxP2bcxhEuHwckYUl8UectrnZ
	 V3gtwoNuWV8am13z6FumAmydzKUusIifsGuBCczVWASghzEpFWIazfs37dv0QtFXd/
	 2dQwQefezmLO2Bh7GCcJWLIp2I3odfpDUu2+q5cUjY2HIBEIZpULzlsAHv42P451rX
	 AMbzQcoo9i5yTqfrE66CChwm33KDOjwuDlJ7PQsrXj9zW1pBIIBRXAe8UM7dWEYmyt
	 p4WJHmaLqRm/w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A2A3927056;
	Thu,  3 Sep 2026 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] USB: replace page allocator calls with kmalloc()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178840081114.3041656.13596134068099743678.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 02:00:11 +0000
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
In-Reply-To: <20260830-usb-v1-0-aa349c302246@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: 3chas3@gmail.com, duncan.sands@free.fr, gregkh@linuxfoundation.org,
 johan@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 willy@infradead.org, vbabka@kernel.org,
 accessrunner-general@lists.sourceforge.net,
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83CA940007
X-Stat-Signature: q7qfkbd9ngp9zwaqqbiz5jy15hecbzw9
X-HE-Tag: 1788400870-713571
X-HE-Meta: U2FsdGVkX1/z3sT2ozf3Mw7jw9TT14gYi1EJx98qO+uavWkfePkKlne17DXZ64X86BBbKvIO5XkGvDjj24rt75YCpMJms7UOym368bTTwqNxG31rdAOmRi5gIsdTlTpCd4fAS3OqZptSmYNOoeRsDs+IVqIAFZPyeRqkkfy3WKIFk2c1qpUIPNft6FQA2fy6kFPaDibIsOCrNFjtXzKA/sxUrkzAe0WV/fbqQsfBngTDLQ1Rx8zSRzFNL72/7VArw7Bak++CSuGjG/MvxRCi6N+6qWMUNNhSurOrAyFIaGKyQuHjHUNYmOuacDH+CeVqket5ba1Gv6UvoH36mXwcq4Dzg4pooIG21Kj1NF/VTv8dU36yB+BkIAYtGocLE8oqis8F3t+i18yxxx3BdDAsDGIOinNacaiJQCprfmEleWKFQZwRBudoRbVJOg1XIZK8B2+gsJ4SxeGFETr8AQpr8BnS+0fka+9t3HmGLjqKprHpHQcdd6NJa2OKPktSXwEjx0XH3C1LGSYOSVyiZ1UmY8ZeeSzdrB1EJO+jhFZTcxW5RART3dRD0ZeHfoYjzBF9M+5vTA1v7+wmx6zBzxwiXbLC95p6SzVskjCQz9NhnO7a3kQxyN9E0i3LREj6+udn+ovC+BbY8uI75K9RivQeBzZOSPUoz+cXe/UpYW8tt3YWjjWBFHlEZZA1auqUyfYMSPI195TKAaEWeOL0eijloQYMmk8ehtajvrrjP1WasrydoNnN07gN1Gj1p4tcT6M7k1bHTdE7IJBbhlm98VZsb02XGUmMXspiqTpYh8hsYIPeJGrKfYcnwN0kXJ4m4DYOuVUr+FFCUEKNWNMYztHy7JOziGH5J6oj3+OorIJwiDPWDbp9Jn99EQUZlRh+meVZeVs0ec/+QUCpQe8NllvINyzNML0OIerCW2/BqN65Ko/ku5kYaOVursfyVSo9avdro/5JnQrV1crIzw2s6py
 rtR11cSF
 hgN2BDTr00zgVXk2e3gOnF3pQ2CZB+Uoj3oFG/K4GpaTPvaSTfNcmvl3rZGBQvU7LPW8GvdK1qkaw6yEqsKNePkynONqiSW9OcKy7Uex3t/P7MbY3RiDTa0pnspcqyvnxnaEQUi6Zgmf5e7J/TZ4Mn9qn9Ug7lQycJQeqlhDQsk68qHkI1OCYnjg4E7WTfWTxuk/g86EbFFn0liXgVbNVEm2UrWl5tzT5uMM3vKADroT4ZchrNrVgTZspGLnEHU1HXUttDfrvXivn+QlXVpsMf/s2dQ9ZchfI+k2Qpg8lP4mO5IQNS/6vXCgNYI7z2l0sSYAdVD054praBnwYy5wIc6lJ4ELBHYBNMaktd1eYv5sCtRvU9EivO+zOPafmEJOIQyzG3ZgUPid6HMfHepVkBR2aMAxsFkoVHdJc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 30 Aug 2026 11:10:36 +0300 you wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> [...]

Here is the summary with links:
  - [1/4] USB: usbfs: replace __get_free_page() with kmalloc()
    (no matching commit)
  - [2/4] USB: cxacru: replace __get_free_page() with kmalloc()
    https://git.kernel.org/netdev/net-next/c/a3b4826138d4
  - [3/4] USB: speedtch: replace __get_free_page() with kmalloc()
    https://git.kernel.org/netdev/net-next/c/534b18813974
  - [4/4] USB: serial: wwan: replace __get_free_page() with kmalloc()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



