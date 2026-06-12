Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6E9CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DFB6B0005; Thu, 11 Jun 2026 21:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE446B0088; Thu, 11 Jun 2026 21:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704386B008C; Thu, 11 Jun 2026 21:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED556B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:01:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDAF7120983
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:01:27 +0000 (UTC)
X-FDA: 84869457414.01.6B07E2D
Received: from outbound.mr.icloud.com (mr-2005d-snip4-7.eps.apple.com [57.103.71.100])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C4FC180006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:01:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ZifDkhrA;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf16.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.71.100 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781226086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENJo5KFsEuvwMXawIGe/hJt8QXbS3rri3BHvidL5wZA=;
	b=JtmHVSyCCmjPeamlAM0a7RxWMHGl6cneHiyxN4VWizMLte/FjsR6IqNfGL/SNjPxvwvSNk
	mODKxA3eGogogWQ4SUcq5dIwjpxn98vEsiK7Jq9nzpvXKrJ/z1cuD5KzdWtGebC9HNAfKb
	tecFNpANXXjGXyFQeqdDy1e4sz5hkug=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ZifDkhrA;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf16.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.71.100 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781226086;
	b=sjz6it9NLAvToOxI5r+TrBtHOyk2PWhV4VWpfX+86CQ5U68w/nb4xoeH5NjDbZKex1ysZs
	+LCEdUaRiGiq/5F0k/c2msc/8Ns2CGKzZzzJpbHKezZeTTpnN/Ak2A2aiRPoLCCIp37wC+
	ihebgz6CJB4KBPy4LXtVKXhYzzmdsKI=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-5 (Postfix) with ESMTPS id 5970F180012E;
	Fri, 12 Jun 2026 01:01:22 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9DCFhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQUZWhlWM2ARcAp1AHINAUlwOH84fCpwMXBVfi4GVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1781226085; x=1783818085; bh=ENJo5KFsEuvwMXawIGe/hJt8QXbS3rri3BHvidL5wZA=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=ZifDkhrAjGGitA1tEP/oby2WQ0mBkLoERtFbQfaKKILVXHN+bkset1HCrEY5Esg5WONYh5aq/EhslNBaYUqyH65kbpvwFpDubOfU/kllgXHhw8/cmWLbhcMmpJbys80acKBgYIV5Y1FexETd/qiOnwQsAyQqq3z6zMCrLTOZVT7IcUiIhVufIu76boEb6VqtBRXjDwYqXdEnDDi1RSy7yfXFFMOXNUBacSzR6guhideNmFUvJPqym2MAiJYCbAqlHg4b3Qwk85q22e3ZYXHYMiyNWgJdSmTCG2COhZcah4/bGtiWoqhbohpIRIpr/b0Q3IeRGbkn19HKbU21QKiWTA==
Received: from localhost (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-5 (Postfix) with ESMTPSA id 2F3B61800204;
	Fri, 12 Jun 2026 01:01:21 +0000 (UTC)
Date: Fri, 12 Jun 2026 09:01:17 +0800
From: Luka Bai <lukafocus@icloud.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Karim Manaouil <kmanaouil.dev@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <aitaXRaIrFmEf39I@LUKABAI-MC1>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
 <aigktfOjYwxhzEhb@lucifer>
 <20260611092313.7d4knb2irt2rtswu@wrangler>
 <BC930D36-A35E-4D68-9DA1-914E4223FB6B@nvidia.com>
 <airtUk0t08o63me5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <airtUk0t08o63me5@casper.infradead.org>
X-Proofpoint-ORIG-GUID: oZXojfgB9yzxZ6mJbAzK95pAkLJBcYAW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDAwNyBTYWx0ZWRfX1SozYRzGGL2m
 e/An4T/1gpb2UlVu/lx3lIgDE427nPgIgF6qkLXwLGF0s0EH89iOglasGerPRyUIo61gn9QRK88
 2JP/VeHxeVV6eXZaVLtU6TFG8kxZqHQfxcReDQtZWqyyko0//BTNX+1DnhaddUqEG7UODAPac/E
 WYbQdYddzJNcqPRvlWvC4pRqUKnioeKVgXnGigIpmdYiuDXqVaeSThMO8zhvyK1yi4/YM6kb5Tu
 MFEzSPDJEsoZcwNhlmaSEGDYHWN6mWJ2sT6u44XIJmBclNgNp89LFpkZbaAGsNFak2n0jYwm8ag
 QQfVAx47HZLl76vjR2f
X-Proofpoint-GUID: oZXojfgB9yzxZ6mJbAzK95pAkLJBcYAW
X-Rspamd-Queue-Id: 1C4FC180006
X-Rspam-User: 
X-Stat-Signature: xnpr3gpwucsx94i7cxdcfiwgo5p55k93
X-Rspamd-Server: rspam09
X-HE-Tag: 1781226085-520064
X-HE-Meta: U2FsdGVkX18jFixpHo+MsPNVfHwam3Mjx4wBa/d3nNCqclWLSZihokkwC6IRww9pQC02cmIZ02ce1oGf9/w/vH9B7q6I9+npN+dxHqy3eFiFjwXiSeJLldNf0aMs4WOW1B250i2lhNlCpIukqo/eVD3fXe1U5BbtklJ8eyzm7HnXaf0hsnI8XBp3OmwcLmKhHdRxvX71016uoLM4rgMYU5WHC2LMYwAooOQnOCr49kJjYRjB7Z9cqA76g4nnz+tIXFQGJrNlefY9K3U4zOviG9+fqBRkoVB9yh85N11LI8qxNHqwongXz2xyDGtKHj7fbE8G1btvNtrD7XemGyuHwvL1AYgef2jAh+HkCMmzTfSKtQB4/feCZEAOSFV/E6v8XMYHt1j2LVl4GVIMxnzF6LG3zx+xeigDKQVZy+Xm5wk9Desj+SjcGtgMCfPbtE/Axbwuhr08lsvGEpiD0K6+x31eBdXIRTtjTAvPO5X7D9P02EYAkohO4H3VwAb7CUfNfXI/MPKLEEFgVeUesD+9/HvYyfitZ9cUyCVEClkiEYiOWGDsiE/wXHIhbZegx6zNHDOearWEhsEbMOZnkoKUycCkhphmugOidNEDn75AnCjOa8EarkR8KsDhZoyK9S/c9aYB82eXeKea3OT0k7BNzshlPqqCoL57DVIGQWDrKx+HKvQWJajR2/iTCARnrtguks170sFelaRxpzNoULmOkNVcQcSUgJywiGMHx4zpdLlyeQrjJD7glohwGZkZVyxxi5P5/zPEODf2cqlfQiCDa9ZlzPL1jVG2CdOrA8Fnrm1QPdkoAJ/PfYv99km2P3Tf/2nZswjLQgGxfComFc1XtcOwroZNNyrjJuaFt7n7mGBZ8dGPiXvC+PfxtEpn3mrS67Ce+bE95JpQpNhqkrlBm/TbzrOt9HiS6e54BjjhjweiBfFVqYYJucYLZp69cdQfbSeCpcPpSehBWfaq+01
 55hW55Fk
 20vanujRsKZrp7L+hDDHvPSHvMwrzpNi9y5EsNgvvLfohQAyxdD8ZPanVLumcy6VY8MFkDYDj3CI1TPR1EoLMBrKGpEFV8JanGO0tSkMloZkpv9ZgyYSM/663C0HIBtzEa/8oSciYejwsZqDzdWQV5avDbbFa0rJsPuUmNrBMMxCf8QggT1hwTZAjyfGl8fvebhcfEKxl98ZC9CgB1RMmnyxPsmpf04bqi7vGBbV1DJNrIoT0nnzTIEJ3hvGFRGYBVoj5icV+Xo0qyDDY1cSrxXjOon4BEE7Q+xq46+zhKWGaI5CQdXnjB46hnk6e8NkzBk8AWuHd7bVDWA/+J7Iz9+Nuh1NWc+K3t8Uaw4iNuZ6trOXUPGNJj6ZW/ysva60lhU0AIC2CFuB+gCJSEWpsBP3ChK1lQ/bRMM0zvu2US+jBAB0QdFAF8GzscjZ4RMX8p6FH5818U4x3FL4IjfdyVXG64rycsg2p44s022izTPjz9bBdOIaAzydcag50s+xQBOhFSpPXw0nB3JDOaGiCmKSYcxcnRGYXIG5+YwtmKQaELGpYKFaMMz8B35iU6xJkqKKKseKOMZMxkfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Thu, Jun 11, 2026 at 06:16:02PM +0100，Matthew Wilcox 写道：
> On Thu, Jun 11, 2026 at 11:14:06AM -0400, Zi Yan wrote:
> > On 11 Jun 2026, at 5:23, Karim Manaouil wrote:
> > > How to participate in the THP cabal meetings? Is there any public link
> > > to join? I'm working recently on anti-fragmentation, which is kind of relevant...
> > 
> > Matthew is hosting the meeting. You can ask him to send you an invite.
> 
> Sent.  Thanks for the heads-up.

Hi Matthew,

I just see this, can I participate the meetings, too? I'm working on THP currently and very interested in seeing how things go on for THP, thanks. :)

Best regards,
Luka

