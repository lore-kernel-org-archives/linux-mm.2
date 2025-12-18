Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D92D68BCC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3836B0088; Wed, 17 Dec 2025 22:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B802D6B0089; Wed, 17 Dec 2025 22:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D566B008A; Wed, 17 Dec 2025 22:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95E6B6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:04:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 114D81A0CAF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:04:19 +0000 (UTC)
X-FDA: 84231098238.11.CCE7C30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7EB10180012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:04:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P0/U53yT";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766027057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1zreL6wCu8sL63uyRIJVQ7XxZ3AiWdb2HKP3OuLoD4=;
	b=ifNFHTxeysBLtLZ78T2D8vYtqwWl7q5CowrNR40U6vIZmdBOwZqb7AeM5EEyADhTF3cVUC
	W4XqEkXhj58O6T0t2nR+W1udljHFNLMasSO7EneMHpCsS4lUk7MjQM8aHGprKDfY2SWyQK
	FAtvuenNXSd9abHwGQv5iaX2s6u90NE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766027057; a=rsa-sha256;
	cv=none;
	b=v/x4K79ay4t4lKcqZW3giIlKeTYuzg6b0yFWcz0MQJf2+hKyZiQ8OrB0t1fG+t4gHaa3hP
	NdPdnTSksLv4bXAxE6eXNtGS86PN9boNZgapm3ib4jBxl5Ze8r0qkblbScny4Kn93Sjt02
	nuIKOqOiPgt3TGe6IRh2505vB++uAUI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P0/U53yT";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E76F960010;
	Thu, 18 Dec 2025 03:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0752FC4CEF5;
	Thu, 18 Dec 2025 03:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766027056;
	bh=fIOlKKCnG/5B5Z3soMSjJpqMLZXmgSydiOBzsThgWAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0/U53yTSDyUYyG5Mbm/KrpRxeea/kzHgl/WvWWjpuYFgjLcssAzMIB6LNJdxsOq9
	 6XhHprjY6ckdMunFWf8k0dpIjYDz1e7FXpUYaC5DMk9GBDViDhpXuqO+v7xgyJYtHx
	 DOrZovSU9EQO4nK12mrfWTvOs7vq/g7M6wfQKeJ+//PmC+G8fC5hlj8KE9tg0crcAi
	 H6UyF7nVPTbfg72NRovBNGsU95pe4p/W6CxKIBjwrxQITI3wxw/p1wZleoSvyRYpWo
	 kQdH5ykILJoAIiS5ev6DLuWxrAQQLij6JdorJWK2BDeLhbTUw7KU2NNRQDYrPkox0h
	 59PohI9Bb8flg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/damon/core: add trace point for damos stat per apply interval
Date: Wed, 17 Dec 2025 19:04:11 -0800
Message-ID: <20251218030411.42049-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217182915.5284d66b58ac7b744b8dcf7f@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cu1d8go5gskfetxggd8ubwbffy7dseuc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7EB10180012
X-Rspam-User: 
X-HE-Tag: 1766027057-344665
X-HE-Meta: U2FsdGVkX1/FAesQlVesyqs8EDUkD0jcTQpwrn0lzeEfG8C6KltMMI4EIUkq+BHTS0YQqz9Cb/g/D299JImYaN+QjXm9BP0afnklhYF/+nZMDxtd42Y36YNIcmQJ5yygU8dY+451aOlJzuf7lXcT/BFb02iv19c22RKwnuMy8cnQDpn//y7RQ4BtEGneqKOcRKXII+jYD3U4L6xI0H57Jxo28U3yAY0b4tyyh8lXegPClQxXQ0mTO9teeaZ4DkN3R4QoY7sWhjLmGPTanZfrBKBqaKrHYroG9EFwhdj7SF1g7e4xGZKm7Vsv/TLf8UzKaPV0oUT2KHt1yBJj2upZGPYAKtYMFkgxwYl/q2wFxCrdCe5IrxiGVpqKhzQYXAPc/QVcGr2QoW1CGGZY610iD5HOk0jfINebtCaGnmwkT67EqbJHBa90Xpli4YtsqbDX6mPY8W/TAAY0yfxEXI11MfV9vxbkmckcm6t29kSpn3JKg8UeulLthhj0sQ/NgijiJlJVRFBKJXK77dAQTDZIpKtGwVpMaT6hWRO7uYNMOCBDoaNyws6Nn4MtaiKFbYEqXRb8eeCi8x/wK3jXV8ESiFh7WYXLWbow0HPL3q5PzWLPbHPQLIfDv4vTQnbVSUlNu0UcaCF3m6tuBwcU/+quB0wMHt426mofy91MP7TwriSXFQW/blp3Ss4CufM3C6LggJC7cLoiQROClYOyedgdR/RZpgx9fm8y3gVxmc6ne0I4Du1IDJLeSVIDP2ES7gPpnaXjq3fyXGLzYQxixtzYcA4MqmwNw8hbq/yr/E6dlLBPJVujjrXRCSMAKz9eWetDBr3ZGPwXwYbJa+0RRNZkR7dSqdHYvngUSuQ1C9OlvDBKTqyCisgqhwk5IeAf6kBWMUGc7voq92m5Zv+duwhaCSI/rLGe7WYWkLrBDMifau1hPn65GFjjuNvYAB5yXjqIk6pEM1NE2Y08B8VV2Cv
 vomr+viO
 IB0AwINpS16WOUBkEMakOkCtEKtqpZOwMqRi2DTJv6LiER1SnTtuX+4goLyAalQpM78/95qGy75w8JkH7IOAI+ZfcxvqV/IZO7GLrSh4uJrwpbKL9RqdzF6/Av0NQYBfWbwBnxya1X/5WS9lRNVAYkOqCGdL7Dn3h/vsn0JGntB4MBnDb0QeSyaGfyRjX8rzIUFwpZdTnKsAdsmDxRyVvHY6MY9GqsPkZEoAGk+2YfjqZU+JjCczgBe/ZdvyqlFQXHPxcaKsSo89qjVwp4/IjLUvSYIBwRXpkv54E9MLUPYUG3mGfgjTadFpKlGwk3RYns6Y1QKfZjH5zBXO6XT7QQKWaiVg+iu5Gtosp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 18:29:15 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 17 Dec 2025 15:52:18 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Wed, 17 Dec 2025 17:48:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Tue, 16 Dec 2025 00:01:25 -0800
> > > SeongJae Park <sj@kernel.org> wrote:
> > > 
> > > > +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> > > > +			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> > > > +			"qt_exceeds=%lu nr_snapshots=%lu",
> > > 
> > > Nit, but it's been stated that strings should not be broken up because of
> > > the column limit.
> 
> screw the rules
> 
> > --- a/include/trace/events/damon.h
> > +++ b/include/trace/events/damon.h
> > @@ -40,9 +40,7 @@ TRACE_EVENT(damos_stat_after_apply_interval,
> >  		__entry->nr_snapshots = stat->nr_snapshots;
> >  	),
> >  
> > -	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> > -			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> > -			"qt_exceeds=%lu nr_snapshots=%lu",
> > +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu qt_exceeds=%lu nr_snapshots=%lu",
> >  			__entry->context_idx, __entry->scheme_idx,
> >  			__entry->nr_tried, __entry->sz_tried,
> >  			__entry->nr_applied, __entry->sz_applied,
> 
> because that's just crazy.  Let's use some judgment here!

I'm fine with either direction.  So I understand you want to just keep the
original patch without this fixup, and therefore no action is needed from my
side?  Let me know if I'm getting anything wrong.


Thanks,
SJ

[...]

