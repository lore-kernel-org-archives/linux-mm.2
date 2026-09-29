Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EED6C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1873C6B008A; Tue, 29 Sep 2026 04:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F6E6B0093; Tue, 29 Sep 2026 04:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C856B0095; Tue, 29 Sep 2026 04:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDC916B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:17:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9FE1120451
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:17:31 +0000 (UTC)
X-FDA: 85266095502.28.20F2683
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6620A4000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:17:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aa6Au49P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QoHG/n2/laaRy5rYicMZNSwTjNxom3qwPZeDoYqp/s=;
	b=qFnQaKxHMQMDf18saihxb0pf2zA+SBSvEKTBe140rF5U/0TwAOIy8DOShRPuciyukcVBGQ
	51TQ6i0BGeuycXsBGaqZfn3QxLt2fOS36ES8tYU/kEYXD4U26ngyWyL48hS2yvQQhKbTRh
	OOLMPV+VEvjj4IA/89z6GASt9UiawXg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aa6Au49P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669850;
	b=z4x90W/GHR9MyjgW1ndgdh09W2IPjjzGDPXwjtFI+G8q1Nmi26g3GY4q3cioFDhk7jE3nj
	XMMDazF2baZhrRK3ZBGRwZVSwjLiFj+Ctv/Lhwo8cG6vOO+OFayyFkCz+UDxKQFHs6Arq4
	ZAt+ip3ZkWP9Sa/hl5sB29gFyU6mF0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6B2760A5E;
	Tue, 29 Sep 2026 08:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3471F00893;
	Tue, 29 Sep 2026 08:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790669849;
	bh=5QoHG/n2/laaRy5rYicMZNSwTjNxom3qwPZeDoYqp/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aa6Au49PkqG2GJ9kFSljN4pEa9AfiwGP+zm0xec/WFPk3XCdHnxy0/mQTtM5eAnGA
	 s7G3E65Y+aG80L2rH4F4OSARJoQLMPrcnkmjUrSsOnv7PRqaJIOrwsDsM+TSbsR+ll
	 JKAe5PL/FV+/rYvDCTpa/LpNZp4+X5UjV+hl1KzJST91v6X6+Ca5ZTRyCw+Ry6X4//
	 mUMhaJwpurdZ0dUjkBJ9JPBalAu3dwaJ8b+D1Y59cOKeat6c/AT+RfrXyJ5etx1fT2
	 1aInKxoGrcl4Rpm1V2I0KWaxBa9K4Mn6nDABCh3mi7dLdZleG+pWAnC9Zb0aDZbOHF
	 GRYz++HJvTYhA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: introduce damos quota goal target metric complement flag
Date: Tue, 29 Sep 2026 01:17:22 -0700
Message-ID: <20260929081722.42380-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6620A4000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y6i9t9b6m53b84mm8hue5tm9tseusy9i
X-HE-Tag: 1790669850-204492
X-HE-Meta: U2FsdGVkX198oO+KNWrzvrddlqCdJw2UX2i07/16WJmtK48IWHXdmMX7NPrXDEmq7eVKaRPOfAu3uTmOMBVhn3fkqtZoPDx1yDY+lV9+67aDuzIPcn6c7ns62vvFw5uWQqTsdw9BlEPcp+S6Hsa9QM2VlXBOSOaHEq3y1MmwPxpCLHpgwxmc6Um1kYI8We1aBRV5VDpgXoxHCHdWJtoFHprxVvSYHtM/dNw05jCEm8JQ4qgKXTkAkYg8kp6lQH6rXMaVJQlf7RGYq2UUj9PxImWjC5X3iRQmXX1SRoio0c+k1ZEvRiSAyBSZOLFZYelnztZuQrY45OrqMmQ4ApuJZX58nxQYRipHEsVM+1WOcz0cynT0D33pLdcKLGm1gY0UHiANkSoDwa1T7ZyFn3p5j2NCx92qN6rz0Y6wV83OKnK0vLHq1HEZfBdqQrYriKGs8SsQXxL38L3j9TEkC4AJmkUFOBdw2ZS8teB4fS4cM++RTbFVsQtKNszOVY9hXVU4isLcaQku4tfhZ4TqdhOzGn5VEZWVK4gWL0HR2FlsY1j6e5CjcWIG7vJoMn0Yg7GXQNLPJ/H8vSEn1GPkWI3IDtDwLSpCWVs8uZE/a5y/VcZy3zxXt/lo4320Qt1HueuFWmFzSJrZotulgMH7XHJdfd5NLUqIbKOgSVR6WZQVF+ZKKbMD6szxxwnyNgpIBFoasbLJLkn6FqSMOP5YobIcPqxMTjx3NaT5AQke1Evh8i+hSwMaYhzO1FI6t3Fbev5M/5glObA0fZ3iU6L6cuyM9Rn7t54c6exRv1U47uI4NsqrI9PIKv2watpiyuKqR49b3VYWMwpb70gphSnl6X8XUvgVYx4iD7xyqn0MDr+k5X0Y9ka9poK3sCW+hSO305GkyNy67fIVJx32QeI0P2m+v2dXGC6jlKS/OHDEyyC5pk2JKVXo0iL3U1kYtsQja6YfgM1jsbLcX4VJc1150ok
 4ezK3l6J
 7JWSwv9v1bnvMOiRwzYmA4K85bexC68JmNOe6pEvgbojzBIUKoc6gnHMTekHsja7kbAFPDq/EL2WjpQbDqK5DSmdu3l7NVNWunB3VVOz+g3A6kFfuZgk2P3RqXLU+ADIvDVqiFosG4XvYseZqTQnOK5b7xS6V2mtg5NXXbM7Fqulpx+DVoA5+XiK7lNS5v1KP0gwl953nSSHSbucrCBG/YXoQC2LZ7rFmwgSzCaGydZ+WqAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 01:01:03 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> Add a new flag, quota goal complement, to allow flexible tuning goal
> setup without unnecessarily increasing the number of metrics.  The flag
> specifies whether to use the complemented value of the given goal metric
> for the tuning.  For example, if the complement flag is set, the upper
> tier memory utilization ratio metric works the same as the free memory
> ratio metric for the tier.

Sashiko found no blocker for this series.  Sashiko sends its findings to damon@
mailing list [1], and I reply those if anything needs to be clarified.  Please
refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

