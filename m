Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16CB810ED659
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346E86B0092; Fri, 27 Mar 2026 07:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E666B0096; Fri, 27 Mar 2026 07:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260BC6B0092; Fri, 27 Mar 2026 07:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1811E6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:57:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BDF01A10B5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:57:48 +0000 (UTC)
X-FDA: 84591693816.06.3A2E844
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 95A6D40009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:57:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=wp.pl header.s=20241105 header.b=S3bY1HHY;
	spf=pass (imf17.hostedemail.com: domain of stf_xl@wp.pl designates 212.77.101.9 as permitted sender) smtp.mailfrom=stf_xl@wp.pl;
	dmarc=pass (policy=none) header.from=wp.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774612666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhTOyR8UKqY7SHJz5GHQLjXDNtmpvnLdVDZzqV+XcdA=;
	b=25REecEw3V7yue2/DipmJ7WtWnS5sgX9+d+GtQSjPd4UhdXqDZowBAOnmX2G2kjiLS+Mx4
	HbL8aOGAg9tfMW7ZvcuLzZrXIvAo8qmvpXRCBOF3gAxHcYCfwuo44xlzZ5Tz9pPsQACZtf
	PSPooDAR4NjmkfxE1wIKHkFZ/95nDsM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=wp.pl header.s=20241105 header.b=S3bY1HHY;
	spf=pass (imf17.hostedemail.com: domain of stf_xl@wp.pl designates 212.77.101.9 as permitted sender) smtp.mailfrom=stf_xl@wp.pl;
	dmarc=pass (policy=none) header.from=wp.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774612666; a=rsa-sha256;
	cv=none;
	b=VyiBsLCkT8ms+8hd/xdZrXCqP2k9I6WC45iM9lxp/oK1uWq3Oj8IJAJ5yjjThCM/S8R3FT
	Yo5xzDVj38xSnbqsslkD+mppPC43EB5LzHs3IXXyCXORiDh56/V1olgCRTCFrQPkSxtMTv
	yORH47Kr3Uo2jZoXywdnmoo5SpemBx8=
Received: (wp-smtpd smtp.wp.pl 8113 invoked from network); 27 Mar 2026 12:57:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774612659; bh=dhTOyR8UKqY7SHJz5GHQLjXDNtmpvnLdVDZzqV+XcdA=;
          h=From:To:Cc:Subject;
          b=S3bY1HHYPKHernBCT0RMFPrtZRssIWCxkqHfL5/fCOzfr5qUTHh/sg6N/sbNdxDJf
           jO5p17BB+e/SiBcNQlxoPOCCJzVxg3Z+LDCn1NI/8Dbe4MCEsyJRv6MLRWxb8tw2Pl
           fEXiVvm92L+rpvByZatArkAXEwTp3ZdgjZGTPFwozoeO8zVOpc6JVAWe6z1BsU+sF4
           bXlv2s2vz8e+rHmDa31b9+GF7vm6lFvFmurDdGVyCnP7a+v+H4h8ut2N1+hy+tDLJ/
           eVJcTVSl7228LX/HbBqeaVslVfxnblUjGtACKc8DnIFUZ6TWq/8In6xsNFrOzeZCfm
           Ha7teirKUZngw==
Received: from 77-236-5-223.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.5.223])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <jackmanb@google.com>; 27 Mar 2026 12:57:39 +0100
Date: Fri, 27 Mar 2026 12:57:39 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Brendan Jackman <jackmanb@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com
Subject: Re: [PATCH v2 0/4] treewide: fixup gfp_t printks
Message-ID: <20260327115739.GB16800@wp.pl>
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-WP-MailID: 935123e2e45b6b0ec231f92885b872d7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [weNh]                               
X-Rspam-User: 
X-Stat-Signature: j5n48zqdybm54i6jj79fe9qd1qyy6xa4
X-Rspamd-Queue-Id: 95A6D40009
X-Rspamd-Server: rspam09
X-HE-Tag: 1774612666-977054
X-HE-Meta: U2FsdGVkX1/Io9kY0xta5CxOFpuwItKaR2Taly0aMf1bw45umB6sIO6PAjgblxNEdBAsBEoeoOO+sH5kTs1NZRqG3LcQHIQhz6mW8sVjzMMVMYAkK3PHq57GaaemLUdZuKlqNnYVnHlyAtfpFft9H01KoWzmYHdjm5KaMAYwecET/6GIcl55T3NnEL2ztRgbyLuwGn9LYkOokWVXrm5wcM+K9JRAi6Q2uUfd4qEJ76RXXFB95zW+edUvM6+ynJwVeIuvVM5NE/m5iO9mXkBUDGMNmJXSJ8BUtJOkEv+s+/Y10y3PF/sim8OIR9I1cYA8ukHFbMGNklMXsCnM64i4nrZSn+qqzgB57xmMxS3MmQlEDbW0yNdQZsoWq+S9/Kh20QYuIGpkemz6HVK7BBr2sgegNXArarkdDD+Zbm5bpn3sAGfBsdPcP58i4WCHSzDGN3lRVrgDJuUTzSRwqFupjQno8mEUPCHSLe0Q9vEyu7PsGsVMv9BdAzpysM64zH7Gk4T4C5j62Ja2erCZAI4b4fCtPyy/H1rJ441Fd1rYIdaZ5goFT4H5GIVa+VtLh4UzuiW6ppy/z2Q6pbhxwaasaFM21uJr0HAI3sWap7q7vpJDvRo3pHlL6DDGFQHnFvG+4cm7kKgTUsT0WK1xm0qUlagxFSJQ/X8s5GZZiTG1UVyvwirYRqQlgn2jr52EZbD7ImYJ6O/H4TNXqIISFtRCNWfRDcUXOc2PE2KiiU9ugeYKTA5o/DZIvUew/hYnUpf97VJQZ3YhI8Kmbyo1ageBVS6DaZKlhaE9RTBeNj8pnXFGCoiychxAsW1J3Um5AkJQUCIVE5mAECSg7LGv4/4ab/n45uSDXCEIUSEye8PXRksGa1I/41gm73sK9JTnE6v2J7GgXdIsbe5qGrh3hG5dKvrKHZyhxa7vml5MCisr2oLf9L7iZuKnn/VyquEf708HfF46CJ0ZIiBQBmr7tTh
 HZjXSdK5
 lbclHUalWDVAQWUS9bUViZChYjVMCnThDXJEVUsJkrO98wwFzD+0hPxBsr+N5qKE7OoQWDuwBzsYxUqBtVse65HtSWYcHcXhcCr7PfGckV7KFM4oPGAKtiS5xAdbXtoIXiencq4eP2K34zxWUb+uQbtowg9vQcYMDPhosnMFSrvfnH8Lbn4HzzHfeZ/PkkcAmhXQkdebDAGZSTB9qbT/hMwgvYHCIlMe52TsR3JgJs+whXd3u0SYCwozuqrCghNtQfrgIX7R8aw1JSejZgL7xYSsXQqd9TdbMm6jKeChBadjjajkHoHgghcXR8zOnE+X2bARObCyGQeGHvbPt6dBHwWQRKfCPGc8JvJcbaPvtkmsbO0F0qTlqpk0u26IG6hDgZp+4G60k/U917x897vVhjKQ5jFJKhNwtmvWn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 12:31:56PM +0000, Brendan Jackman wrote:
> This patchset used to be about switching gfp_t to unsigned long. That is
> probably not gonna happen any more but while writing it I found these
> cleanups that seem worthwhile regardless.

For the record, these patches are independent and could be sent separately
to the appropriate maintainers. Doing so would avoid unnecessarily large CC 
lists for people not interested about the changes in other subsystems.

Regards
Stanislaw

> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

> Changes in v2:
> - Drop gfp_t changes
> - Add correct CCs
> - Add minor fixups to preexisting code spotted by AI review
> - Link to v1: https://lore.kernel.org/r/20260319-gfp64-v1-0-2c73b8d42b7f@google.com
> 
> ---
> Brendan Jackman (4):
>       drm/managed: Use special gfp_t format specifier
>       iwlegacy: 3945-mac: Fixup allocation failure log
>       mm/kfence: Use special gfp_t format specifier
>       net/rds: Use special gfp_t format specifier
> 
>  drivers/gpu/drm/drm_managed.c                  | 4 ++--
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
>  mm/kfence/kfence_test.c                        | 2 +-
>  net/rds/tcp_recv.c                             | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> ---
> base-commit: c369299895a591d96745d6492d4888259b004a9e
> change-id: 20260319-gfp64-7a970a80ba4e
> 
> Best regards,
> -- 
> Brendan Jackman <jackmanb@google.com>
> 

