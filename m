Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F7DEC1126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF2A6B0005; Mon, 23 Feb 2026 14:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACEA6B0089; Mon, 23 Feb 2026 14:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8CD6B008A; Mon, 23 Feb 2026 14:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A53386B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:22:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40920139F49
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:22:20 +0000 (UTC)
X-FDA: 84476692440.01.E7B55C6
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 590D1A000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:22:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eROIpp1q;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771874538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fs+jbOjp9m95hvh0abogRCjxKuGRNz+d/0oMVhxq6Y=;
	b=mVrzazJpBYpV9q8fzZlg1dC6Io7L3zHRxJ+tSCoTGPw7/nNdVtquMv27jVMBAzIy5Yhx05
	aPmhQsmi3fy5mR235K4jNKSVkL8mxM0AARoifOohrnEglX0a7qKVTaEuPCzWALNsKBFuCM
	21XIeFW1/vZePHvphcYdLDtsX2p3Syg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eROIpp1q;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771874538; a=rsa-sha256;
	cv=none;
	b=Uu6uulDV/fILmtA6JAriK0HVdrBKhYhEJuLNboopmoquPWBI/PhM3Z4V1H8qi2r0G0BEHH
	bQNu6RxWn8LwxdyxvDvf6dPhGKoSVAPSmZqmvAA6AEeoR00xZhdizrkDNO3d5Cd1B/m50x
	FnGyfQ1af9W0pt7CPoxGDv5Yg1daPoo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771874536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fs+jbOjp9m95hvh0abogRCjxKuGRNz+d/0oMVhxq6Y=;
	b=eROIpp1qpu/ongCjVJt/Z7mi5OTUFZeytb1N6rgy/KilNgwptKOiSSrU/uiBcoR2Mjf5Ks
	yiZvwpN/ejN28iTK/SrPZO+EQ6qeJNmeaum1gqkqmppG75WF5zNIcx8DwIdabNZnLym9Az
	KJ6va8lZGDzVIGSDJTIkF2Pvdm2ysiY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Uladzislau Rezki
 <urezki@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Michal Hocko
 <mhocko@suse.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Muchun Song
 <muchun.song@linux.dev>,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmalloc: streamline vmalloc memory accounting
In-Reply-To: <20260223160147.3792777-1-hannes@cmpxchg.org> (Johannes Weiner's
	message of "Mon, 23 Feb 2026 11:01:06 -0500")
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
Date: Mon, 23 Feb 2026 11:22:06 -0800
Message-ID: <87pl5v8dup.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 590D1A000D
X-Rspamd-Server: rspam02
X-Stat-Signature: q583j9mc1z6n71bzga13jgn3cwukf7jo
X-HE-Tag: 1771874538-741497
X-HE-Meta: U2FsdGVkX1/Eb+OkiEyFgOlfpVSBnc/21NKo+ouIYGAqbamLKB9iqLaJnmkPMGEVtTqjwRDtoBNHnUnqaempIpcIWlbGh+5kbXfvfV0Jry1wlhU6RrIUxmNB2LxCXZx4Nxd3xGjNCE4F7CrDt7oNz7G/a/17eUm/mzJGhiIf2CRuqQbP3UrCGPS1AbUO+O80OnS9AzveGg30vBSXM55JmwrDTexpJ++f7rhTJl7q5XtC0rwmU9EmGNfAQ43OpLWs7PVaEiMdARpSQFTv9uIf3/sSfM/iuV+158CoUo5xXw8EXP0li9ecIpVgGGh/ob17oLxrnYJArno1qpA01io1NULqOgviGiPjfEqnurbQGhQQKPFgpoBVZ+EeLEg9q2QTjZ8X8tVYsRDrNyOny1NoKP4yUDS4hi0YuEIUJ6wKFl/KE9/7SMqH5PDYLIpOr29ov38H3XN3dc9Wv9kTOU5rnwlBU2dBPKC5R/VtuEX1tqMMPFdvqkG83si3ftItzmWcBjCZgTpn9q2Ca11uuK5TK4d/pwmWwLrxi4gx9wAiO5AW9w0jds6HXmHMjaDZe7FTVmHq1XOg6Az2I51WLTJ+k9XLNExt7faOoZ2Bc0ACRLpEOeaEGSkLE1QqR+Qmb+cNJmpw3/e4QLjVqgnyQ9R+wE7o1YePNgdufA4V9UItPQ00RlrR6lVJeFdgHtdczLUL7GJMtikXAfbzxyAuEMiJ36sq8yN9SM+wXlbsAw1yYzXUUONObU2bwMpA7fVlgIrKygjTgFDxeA/L4O0U4ez+1Y/cfR+ZnLITpXKEN9SzckZDgItlZ02u8R21iJ9sZ/LzPB01pCmEIfxwwKYqbCl3ermFySdNmqoDn35Cebo59jtmpmu5xOC5yxc4H/W/1GV9lQr6sImNKADvx+qC3LOqEMuV5wdFoS/KwSdzm1Lv+7BS1jhWwfVjjNe6MqeaOsf3/8BtV8DAANNSt7tVMJ8
 05z8tNKa
 uLvPu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Johannes Weiner <hannes@cmpxchg.org> writes:

> Use a vmstat counter instead of a custom, open-coded atomic. This has
> the added benefit of making the data available per-node, and prepares
> for cleaning up the memcg accounting as well.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

