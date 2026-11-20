Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6060606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpxwFu+d
Received: by kanga.kvack.org (Postfix)
	id D43D36B05B5; Fri, 20 Nov 2026 04:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDD36B05B6; Fri, 20 Nov 2026 04:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95E76B05B7; Fri, 20 Nov 2026 04:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F49E6B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:23:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15F89A8D7E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:23:40 +0000 (UTC)
X-FDA: 85454959800.12.FD1A1A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 80E4A180005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:23:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WpxwFu+d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795166618;
	b=iJCK0E/G+pYadR2ZKf1lkgQMxhxRlpld+3WlEz6XClEZuFjBV2ZHtDyLx4R51qpqOmuzs0
	85/VF7pwc7xilQu5aXYaR5BkRD5/kurxcgFN28O/Md6weRLMv5MZY3UvWX0/CcW8fawmZO
	Mrj3UnHiejeKMN9KYUr7Dnj7/Xj93Bc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795166618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHW4M+q/Xhm54NFX+3u4JQAN1oFui+zkbZJdU7S2zo4=;
	b=L6z/lvNlzawClKOcrV7quqHXq9skTd2Si+EpkYv771vmwmouDN1M7PlI9TMADePwYO5jzK
	r1wvXYkWgNJ1TCo7WOPZoy4+r3Pz5BU7FkgP+ogJOwuPIHlFJXEylxlqdMUdGVOyaBOZWw
	rLK8aK5SrE9mPW7lAC+geuzw9vRgKic=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WpxwFu+d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E57654377A;
	Fri, 20 Nov 2026 09:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456E71F000C6;
	Fri, 20 Nov 2026 09:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795166616;
	bh=UHW4M+q/Xhm54NFX+3u4JQAN1oFui+zkbZJdU7S2zo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WpxwFu+dBnk7TT+TAVvOCeGZiO/i95AKNUlvowfDJHUSAgOn1AMEi1CBG2K2tfp/Y
	 kRb4JmuT6xjrixrvoFrF3oQ1dT0X7AGsHkqw9WO6W/M14RzpjVe4aYupuKsArGkDRl
	 PcbsYr6xFO+th1S+LgcDKGkvCqZSIpB6SvOhYiq2nHQ7gXfsN4d+TzFutAxgThIqwj
	 CcXL9FpFXNqxgNeYqb5bWnsyL/0tp089iVZpGhFBSTPltZGX7jgip7ZzjQSuFF/UlC
	 ixURzNPzCCy5x7y4QtCO7KfNLHpovSsxg+f7b/rGq0BoQQVR7Fym73XF20qh+v5oS/
	 UlZ3cr8g877iw==
Date: Fri, 20 Nov 2026 10:23:28 +0100
From: Christian Brauner <brauner@kernel.org>
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 08/19] liveupdate: Let file handlers retrieve into an
 existing file
Message-ID: <20261120-gedulden-rausgeflogen-spruch-cea76174d5e2@brauner>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-9-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261111002358.1842967-9-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80E4A180005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: bhsq4rk8wckp5whj7neyscjz4i1kraxz
X-Rspam-User:
X-HE-Tag: 1795166618-789618
X-HE-Meta: U2FsdGVkX1+27cxOA756+uwM54Bqu5ZiM5knVm5HCNbHoairQHX9qVoE1z6Daab5kepIYNJtFVlUB3ybu/k2oHTzQJRC90mX5Bk4iLVQQIaeKvS7+HbYOYMs01RUIAoe7OV5U+AbgYErDGu8M/LBGk093nnvvvcq9VSEBGXqjSvunJMgmNjSzetWl3U0fURuo0PwFQ+Eb5rXuWlKJjec/SOBuf9OjN0NxPCC4s+de7aDcNCLTIWTQALy0yr+cGp3D0brEhNIQASEDg5ncVUmw1+5JrIwQjhOA59Lx1OnARLctDitqq4z3WjMKsDAfqOOiXAgaQR0Jy+r4rciA1k4ALhEAScpEFbDHGppKo6YnnPl5jwgV7DJe68vgZOxAJOJDoBGuWIKQxIWXThKBffD7sSJKmv1NnYAKIplzxw11l5zg/ugOU1S3LMQEjBlr0PQ5wpA6l//f+3vz/JWBosiL4dVZV1iL3984ENiIEG2uZVBorRIZ5UdgxKa65GbUv08rUkItpFw2LQzV7EIR5uljj0mla0plp2UhmPLdjk5RtSvesWI3d79k1cOQlOxD0HYhJyp1BYxXU5g5X0wg3V+S3S7Fo7x8BkdDBPAkoNOx2EwI7V0vHkeg8ydV0lv3XaDpK4dZwdQ7Ubz1xyifoHnWHGPLIbfz3XF0l2eGbc9BYr6J7YazeiQZNsswzSw5AI4LEXX+diC1RA1+T5gcKyAsFhDF4l70bmPvBBXjfLWWi1s5hu0m+sJr3qBR/vBuBMMYBr9B3Ll8jMVtJT+DoVjxjPjcClmVFu/tezPj1cyVzujdADPj3jLafsT45gFVuPSrIJQ91KJPEz79PH1rpIh2Ajf/ZC6e6W6CjhDFRYW+BKkUm5Ao4w4V8a9+t+vs7SY4OWFsmWT/pmzrrJof9/xMvU2hfqU3qaJMuhE5jPqDUQR6I0nDnHTJQ5fFtN0XUSeMNuz+t+wotIrJvFRt0g
 Aj4D9yOW
 Wn3RglWDUgI1R4dlKNCQwVv7ykJoHnvNkpxcAfqOx2OHtaDS6IfJQrEdGV8dfbaQg6iyKnVRZ26mwRCxMRxjsoQ7NqBK1AThVHit4c96tNkxBaPN/iN01jTDCho74reAZudohVFfJrk09ySChMaXOVrn9b53TDXyUvhhU9OoCTNNpV6w1Z9Q8MOv0VjXWxaYB1FI7nWMRO0wFndJRA3BZYvNNcNHNzykL4dWXYzgc60PniBudmBQs45n8yyl4wmOrKAnEcXMvL4WRW4ajc3YweQdH1J4wDhuXyxITr4SO0csc64zGp9iyfp4VpxngCP8zpXuffHo1RTwllsyWUKhHZN/YqZSp64z9bWQvKobb4ctSQZgpW5Db0eZdpTCV867gp1qdqLWoucsU/nieE5x32+rFE+RzgFmLNEXzsVr3JvR7n8O1Rdg08xvktl4okoV27hKqw0gGcuQe2/HxwfLtKoYU717ggUjm8V6rqij92dwvEUqN0rLzHAbW1cZMJIMaTGozoDyqj6IQo6UXA8NWpQeHRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:23:46AM +0000, David Matlack wrote:
> A file that is restored into an existing file is already open in the
> caller, so installing a new file descriptor for it would just leave
> userspace with two file descriptors for the same open file. Retrieving
> the token again later still returns a new file descriptor, like for any
> other file that was already retrieved.

Thanks, this looks way better.

One thing: Please just install a new fd like for every other retrieve.
I think it's pretty meaningless to return the fd number the userspace
just passed to the ioctl.

The fd number is also not useful as it's not tied to anything. The shmem
handler looks the fd up once and LUO keeps a reference to the struct
file:

	CLASS(fd, target)(arg->fd);
	[...]
	args->file = get_file(file);
	args->fd = arg->fd;

Which means, another thread can close() that fd or dup2() something else
over it before the ioctl returns and the fd you hand back refers to a
different file fucking over the caller (shared fdtable etc pp).

That also gets rid of @fd in struct liveupdate_file_op_args and the
special case in luo_session_retrieve_fd(). And a retrieve into an
existing file then behaves exactly like retrieving the token again.

