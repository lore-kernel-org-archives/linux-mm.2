Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD28CEFD210
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293116B00CF; Wed, 25 Feb 2026 04:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A8E6B00D2; Wed, 25 Feb 2026 04:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197856B00D3; Wed, 25 Feb 2026 04:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 073376B00CF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:14:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B24941B6F21
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:14:48 +0000 (UTC)
X-FDA: 84482419056.05.6AD5533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2DB3C120008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:14:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIH9eEuY;
	spf=pass (imf29.hostedemail.com: domain of horms@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772010887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHrXMeo+RTK+M4CBZS98GPDKT6rnOljAOXHoZtguDrE=;
	b=OqKWZ7sg9ddqvDtsAo17hReSgS0u5eyv7InGBvsZ9R1R7INlR789kFNrsupFCLZXqtBDgS
	ThP2VtQYFC34/SD9zlIw2IBj7Zu4pkzbcUc4DRhCynJ2tSZCCT/RpTkI7pqop0PS2Lzesb
	68jW9zFQ7bp1UZcINlvufKrBNioFAo4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIH9eEuY;
	spf=pass (imf29.hostedemail.com: domain of horms@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772010887; a=rsa-sha256;
	cv=none;
	b=x6mXcWT/4EhUYaFh5HgXz8RpWkHI6WKcnii1RT60X6JcR15sl4y8OXA2678fg4RY5rCxti
	hD7CafF9PWb6wt0sUKk/UcCs7HE3WEFicf1rPewrOi3vtrhohAYUDOSq60YazqZe0DtsaL
	/qafiJHN88NhIZ+2trMwD7nYqSkA2AY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C59460054;
	Wed, 25 Feb 2026 09:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DEEC116D0;
	Wed, 25 Feb 2026 09:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772010886;
	bh=p25+5pv7NVZmKWEKuRjfwdQ6ErbXfWp0m5SN4Bks0XI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mIH9eEuYj/i0juLEtIdKqUN1r9o8OYN+mDL8pLrD0iulqzOW5IsanB783jYLKRgVm
	 YlLvCPqT+8O6ploD0lHhcQD/zPKsiVZ485zBqPcE+Wzp1NkgYn6vQI2KCf0wxsMYFZ
	 pPxCEcDlPykOs8VxaZdSBztOy/yvBnk5KqBxyX1sgZGh4LcU6K2++eoSlVnmXBb+4L
	 SExM6s6MPLGVP0Xc2AHURmZScuxYzpe6UmV8oEd+EtzNtSHL3lohpf6EEc8UKa2eKm
	 FU9r/Ii1Xxv1gF52gzOprhZ7UF6OE/7/7UIpZoxEoh4+cH9PZK4e/FxNMufbVdfuX9
	 Dkfk8ARplvrlg==
Date: Wed, 25 Feb 2026 09:14:38 +0000
From: Simon Horman <horms@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, asml.silence@gmail.com, axboe@kernel.dk,
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
	almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
Message-ID: <aZ69fs1_OsqkQfQ2@horms.kernel.org>
References: <20260224061424.11219-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DB3C120008
X-Stat-Signature: cdihau71bypbnowpctsin58a4kje7q97
X-HE-Tag: 1772010887-337257
X-HE-Meta: U2FsdGVkX1/TzfFnTxlT6loKmKDLVn2Mr/SrK0ynvIoPG9wQuNZq0NLO9SO0g/Zf86BCUBrRtHotXOym5CvIb1Laf21oMshukJZJbxNBTfk883+yu846WyYYMKt2EzgMcAN/ppB6gve8/VdDpvw79iU3lAs+8ED8ePJudhHRiJ0VegXDJQekJjEbsVY/5FNLrEm/TzHHgjrU1Msvbrhz/fyXM1W6I2wm6wOPhacwWd+ru7CUsc2+YmfKJB8I5jaTbmvv344Ym/ukGlHnSVERXC0nlWIdjfjoRqbOoufuPiIYzfVJqwZYUXZ5oD+lnfUvrxaTf701oRD09mkTmGIbRCfXLMJAFGQa0jO5UnQ7Ln2WaGKFNd65HQ7xW7PeEhV3YmGUOO1vmZRX76cRIP0XLJ0xQDMM4ydBJza08JEPoCvipzyxRMyAgdm1bVaZVGCDns/q5JYSeFLDlN+DpQh6zCmVYqYoDpbueGUfbRgTcSXDI+1ilyW4eE9opOqrS7rSmb5HJc4TO5LwI0H2QvF7yGe3jQwVw8Y1DGk2XTLafGbyLx9CmEiGfJdapFztURRCTI53TCPhZA0VK0nCp5YMcXWXuKWK7fVd85h9uJgJzRVwKFwzpJW4JqBuYipSMJyMHcU6Vz/T1thCDPQqb3v/7KsvxkiOKv5TGuUIjG7CFg2mzMEb2TO1cP3u0cQ3aN2X326X0a0iXJKlz+oamsR6O8K9RVhnC2UPatZ05enpn81LdSHlze39m6nr2hry3E/EIospfH7A6DWyEKk5PAAh3UUfOBBEIvuGsco9T+Whl5KWXuFJbO9dlTgWrdgICT7gHZ73glW9V1lHsgHEd2RvC7BWdc6Ne3w1gfq28+Yru48TijAN4rIoHJ6GvMM1D+1AmXjkD/iR7b91p4r4CKproeRsX8AiIX1jdjjwkW0seDzl0UGBwf8G5RMSFiP6N9YTQiStviEnmtI8O3MVn4i
 9zQOqX0V
 /brzKTXtOPszrlQU+LbFT6u/6WoTDkkviddxF9EjjxlhtL01Mljq4Yq+MvLQJhx9cTJLRFJOQbcZS+2tA2rreK8XBxqUDb/b1lDg8aG+j2LcZ/AO1FVDMcY6DrwxYEGNs7mIFlcwVuOsGgUxwtN1bicqZNPhnGyoseuAX/VdCPeMHq/O3lfEc1I486+NBP9j15435VqLh4Gny8JFTtbjjBQb6ujtdOnGHJmAB7N9FXpfVQ8fxq9HfZi9iEtEwnz/MHun4XY7ZJI37jQJwTvIzC3Cs5muTlaJCNb0XXNNb4mETDaGjGX/Zsr8CVkyeMdHpspRXnEe7Aj6N/D+hTtUgpnzxQKuZIOGcX6C85DXFdUo9dqFQDG8+Ix6/xZjc//Px9KREj2S9W/IJdahRmuGOlgJAilyFq+mZWpFt94UFTIu6VUuKm2z/Eqix54Qoq+AmJNISeU4u0rG/LYMt7hCZY6bFvgf8qtf8ab7j6vZnhzM6OQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 03:14:24PM +0900, Byungchul Park wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Reviewed-by: Simon Horman <horms@kernel.org>


