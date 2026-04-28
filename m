Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04501FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2216B6B0088; Mon, 27 Apr 2026 20:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2156B008A; Mon, 27 Apr 2026 20:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E80D6B008C; Mon, 27 Apr 2026 20:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F299B6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:17:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F7B01B861E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:17:21 +0000 (UTC)
X-FDA: 84706050282.04.77498B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A1AD4000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:17:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y53ki4zJ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777335440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zhjl+GKx0k/XE1VI9kKHmR5/tcsvu3NiZEt0hGNeFS8=;
	b=8FRa/qdtHKzJRCYfa2iqVYc7MEtLGu/7NzvbEK0apcLupkBeYn2BZPVpfALjTzrPZW0Cp/
	+heNdRYhKl5fyrJTzx4VH8CgsjaW5bMIgRBjMeYds6osFT6zofwj+rfIKW4nySCwAYnMS2
	1VE5Itx/7XBN3TZOdY9SPIYV6ghMOus=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y53ki4zJ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777335440; a=rsa-sha256;
	cv=none;
	b=lAQHBYbKZiJIYpQEbOBa32Ca7AOIRbhxMiwfn5z1emCbjod7TsZie7+bvnhsxx3TvcVUGL
	whFwXHhVVXoK6RfrOiBbb0i3t+071tYKRvLFkRivdzE9qQppcjOSQwPPyk0bZyxgoJfzCr
	32u0qcLIRwadVeQAJOxkw7OduiSH5iM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1045760121;
	Tue, 28 Apr 2026 00:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35481C19425;
	Tue, 28 Apr 2026 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777335438;
	bh=I+XvYRGSfHu9oMRa139qcOeamu3DjoTukAn+yztBlLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y53ki4zJYdMxBMLfhfsQFpV6wGt3v5oI5UYC01gnSmOhxFd3eSPx/WOYFokaekv93
	 y8pkuPdgGil5IA5H39ufdlsFYl+uy291YVGO4FGVfmCbeibmpYHSH+eOJvQigOwZE1
	 WRylEwcqGjPmE6aVbkG5YzuVMX1HuDHHpVTtmZWep276JG/jWjkPH4aOJOdlTy4ej9
	 I/2axOtWf2K8rz/pEBxjuEUAGJ4iAoGEOVziBeGaACCL0mndKRzmcxJ7VtRmNMwRmk
	 hJsoiRC/AAiDfwvWUTQfKBkXLIRzSJSq/GrHa75A6U44IEVff+Cy3zzpFKz6ri2ZRz
	 vNlFxifeRylcA==
From: SeongJae Park <sj@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix destructive tests invocation
Date: Mon, 27 Apr 2026 17:17:08 -0700
Message-ID: <20260428001709.112783-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rxbi9imx7e9rek11iofabeugigtuesw6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A1AD4000C
X-Rspam-User: 
X-HE-Tag: 1777335439-307199
X-HE-Meta: U2FsdGVkX18JF3IG4+KzjTUBSeCnEJLMA+u1mVIgDNz4oyBXTitEpr/6pNjigVGTh2tWS7SL0cHEJO9awd/JYJThPyY0nXI5raza0Eg/IoOOO7e3RQ0jONUG8F/uu4EGPUKrr5MFuNRp8omlgwkX3UMgClZbnQf/opzV2PwCc+wbREkdYqTnvPZ88lYRLV28oXJzN+rh5Y/QOzYFJVwaYRmwvxPe3osyjINYQkx97lBC5GkEcTbJSAi6LW4VhDECo5V7MwWK5Qk5u8B4j5ggkVGBgSZB06TGhza/P4a4mi4+M62fK7OQk6eM3Jpdig2HW0+wa0Al4CbvDeyK1ijLjJDaCu1eMj3Pa6KRWbIzLl9LGnCQ/7HNSgwUeG33KWM2kxkP7afOJyTycfwp/YpKOEO24HMENWvLHACR9KzwUrZkXm9hQiIS6GArowUZ4FWXuaWOW4+ATxMMTmm06YlL2L6lo9dfVORIUkRdVGpcQ/ttmv8amvO6nptlGtZ4+hMSYemkHKVBpD7tH4gpvNu8GQfeiPVevIeYJtI66rsjwHCUAd9fR+vGRDLBRv9YWeapgcrasfVLG1GKjnmZO9W1A2833S0Q/YvHO0fApsS5Zj/1ED65e156uUbt/PzT9FvM5sWuIz5YDmP/RhvfjllHdiweUS2npM4K+sEU95qtIvNm4VtFwSF0YEnY22Jwn6EXKw8O/CBQ19PiKoFf10GHXNCUvg/bNv8niA5r2KleIhR0vIeakICe7Gr2uXGszvLoiw9W9xC8/fbm9ZraSoLvatItReBocI6rQuW+fR5FhwDipA59IMre5UB7qZz2LzD5AGPN8BX9M6Lgx0MwM0W+M66ynP1+yRZwRgM5uo7beqVAG5lkOX9OHO+jJJZ3x3l/la7Fo3wjP1d7hGIcNerWXq6e7yDFJOZvl/+okLa+n6pZXAxVP/EB3fO0XI8ccCq/E27eRQVKJJx9p2JS7C2
 tEdymVdN
 ufUJ2tFuVYpIDrFFzf4GoOBns7u9hilL0Pf13DXMazfx0F6OVX3IUqKKvOybkTPuhwsFdSLoDNqQ0F/OXQrQJCu6fTPnxN1UZetcRb+bbX+r74YIFf67H7SAGsEdlVj151ctPWfJfT/ucNUabImCCYOyDzDeODedfdFgonpBzVrHlVpvupBGr6B+BfzpCeA2asO3X7VlK/ZTQEML5vUBqtvp7jyL2elAmY2ofVo4zXqNidnNRRA/1iGwvOFhK6fkIChlFFEUsL6gtRYy3/3ihUtUi1yI6wlkdmqGL/7G8+dcCM8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 12:03:51 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> Destructive tests should be invocated with -d command-line option, but
> this won't work today since 'd' is missing in getopts command-line. This
> commit fixes it.

Nice catch!

> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

