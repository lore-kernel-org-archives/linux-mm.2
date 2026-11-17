Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9DB606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=DowSCbg7
Received: by kanga.kvack.org (Postfix)
	id 42C5B6B05B6; Tue, 17 Nov 2026 09:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403836B05B7; Tue, 17 Nov 2026 09:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341126B05B8; Tue, 17 Nov 2026 09:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBDB6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:26:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DA4D8049D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:26:24 +0000 (UTC)
X-FDA: 85444836288.28.FAE1C32
Received: from outbound.st.icloud.com (st-2006h-snip4-11.eps.apple.com [57.103.76.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id A66FD40005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:26:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=DowSCbg7;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf17.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.76.171 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794925582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFBQgsUKqn2SeEBgrCHrVNl21tMPPxSMfQjFRoHrS54=;
	b=glD/1+QCtsU9uUMHfp//BuR85vdlifggQRWENS/9rjfkywZ6IU/ndXoV7d7x7qpuX1OMOB
	Vs+U5dXC3HXeKVPakqZ7jcrv+wLMpJ5oM9O6HQzjkrtuyy6oTMnIxaRIzkZAsTkcbmXjBV
	bagg0molNImvf/GkIJgD09Ern0lx8zc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=DowSCbg7;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf17.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.76.171 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794925582;
	b=uLGbYf0xdpV+KEMKgmX9O2TMocvKSKRgtlus4eqVsZP2BHM+IrcEuQqnveyqn+n7koPhb+
	8DeFdlCSKvKFGYVu/f5RGxOWB6hJZTJ3ZIcgVkLAJZAJbOxmLIlwehVF1hC2h71jBRYU6C
	l0jCAc0faZgPfVnc84O5pTbHQfic2/k=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-5 (Postfix) with ESMTPS id 83D8D18000AF;
	Tue, 17 Nov 2026 14:26:19 +0000 (UTC)
X-ICL-RepId: 01a1e9e6-ccc9-71e4-98a9-760f2b0e292f
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794925582; x=1826461582; bh=cFBQgsUKqn2SeEBgrCHrVNl21tMPPxSMfQjFRoHrS54=; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:x-icloud-hme; b=DowSCbg7YwoSsknR4EjggXyYYm02omUQrEl0OXPCqFHbWE55JH3cDwfIUUt8J+NsE64lMfuMsKxffuK/q2uAwbnAZQBhG1xb/iK5EX25+MC/1nbanytzcedOPrCtb2ULBNwwGdUqGr0foKvajRlhXIKwV6uDRXiStaVX6hEBzbroeu8qA7kVAP4kvpSAYON1xehJ+tXZdPvASAMaEpXpOWfBWgC7+htBa/f8jbb5FM/zW+URNJnAlighdoRfU5uBoI6MWB1oh/SzKWHjLICl5pV71q5NAcbWNX8V5K5c2lBkNmVZvuMGC4Jp/olqWATgjSL9lUUZP6wDsQO5zh3qcA==
Received: from omarchy.local (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-5 (Postfix) with ESMTPSA id 621301800122;
	Tue, 17 Nov 2026 14:26:12 +0000 (UTC)
From: Muhammad Haris Awan <m.harisawan@icloud.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>,
 Liam R. Howlett <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
Date: Tue, 17 Nov 2026 19:26:08 +0500
Message-ID: <179492556819.269625.4305215206796797018@icloud.com>
In-Reply-To: <avxPvfV4NxKL58ZR@gremlin>
References: <179489519663.1444496.15875846661591982934@icloud.com>
 <0b565b9c-1462-4fed-8836-9a7d08e4b861@kernel.org>
 <f75945f7-82bc-4ff2-92ac-9ec057347a41@kernel.org> <avxPvfV4NxKL58ZR@gremlin>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Proofpoint-GUID: p8wqqG80lPu0mQwr9KgtBsMoa_EicKJf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA1NyBTYWx0ZWRfXxui4LjhxlIV4
 DypV9iBKoe5+y/yVnE0sXJDeZm/WcuAApvJEj2MSL9X6i6mXYDN0QcTE427VRIxMaG5MevK98L+
 Op4kc4VboUyjgtdhv8pHVA8brD7VpSTHYvWiP6JQM/zvWbhqj3RYEiGkB599+/zZJC8agG3KnPp
 Uj6nBLE4AnKWBkVBQhI4drUw55ueCTDW7Ma3fQiFaD9L7UUJWwqsqb66MFD1ItEzZsoCtngcmVs
 /hNrKDSt5c/LUHu8ydkoKlHFM9+3A3ZE3GLMHIJGuIlGjpu5MFpQGGJ297sKgp/bHS5MoRjhft3
 80FPuvjpLETj1GL2vF1ngWPUaEGDoEAXgHPrtT24NtgHUey4Q9NCfdD6TrNWik=
X-Proofpoint-ORIG-GUID: p8wqqG80lPu0mQwr9KgtBsMoa_EicKJf
X-Authority-Info-Out: v=2.4 cv=ZMDaWH7b c=1 sm=1 tr=0 ts=6afc640d
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=2kFROKt5_e8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cxNFcN4zLupSoemyiDcA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10
X-JNJ: AAAAAAABOQLEpfW9MVVoxxro1LkZWVzM4PxAUYPKMvIDCe/LliswltnyqBAinHwTCNR2oc
 9gVTpS92RTbdQ+h3sFHXgwKPFVx4uqmn9TdMdZdHcrfcYD7aCV75ln1eF02aXQvwNhSpfz
 qbDdn+J4UwyQ26Y/DkBtNRymeyy2eYlK9kM8qqBDD2z53qSLHwjPrOUq3ZX29w02Iha4Xm
 /HdnAhVa2t/MSMZRlfhDwcPXcb0BJZx5XzPtWmQFc650+oaYYWsHRUJuMuX+hxS5nAUqNh
 DS2KVPYsRLvFwDLFzSipOqZ0EOoS0i5BnoPv7JlUydseyJgxdj2GjeEUcLK+IfEVFwr/RT
 fARHhIrV1d4w7gevT+d7dsEABWIgVwxFiNl8M/YfSEtDiqfCOMdszXoI6G0PKMwj5VidPs
 cVpK4JpJmm8lH3HFaeM3FsXAystR+JgNvWd0n5m2zx7Fep1XpVfoXUMYMSdl7/Slwyz7ut
 0fyZYgFfWbonBu52MJ2oEmmbwfRYQxCkl8Z+NBnsvXcv9DqFU158+Mr66uvD/QdTnKIf69
 qAyxCqzoxoY7deB0jC1d8CjN5H8SNPi41EqFFwhHTsTJugGYY3d8MTTrMqoKdKisqNABnw
 T0Uze3OtGdHBKlcHtIbUVy+zF+W0M9vkpJ47deMqaK5sfBAvwLzYer+8xbbIuLwpL4c0Up
 F4dVDxOx5+giYdkXiRzSZZvuLVp+m61LjhecQ8Ppp5OA8kFcuLXZRXSbjhxi78gnHzLYlc
 FPjF48DBA2dHiclucWwoOmk8VE01bfDJSXDtSBvk1uZDsqkSsmP8AeKxRLo1L8fQnwpWFn
 TmXf5LdQ8BSOMMzs1oM6hCx0qgsnBPARbdtCexGvpzwPgBqmJU7SaGIm/jVewn+rdk8PtM
 aIPtjywD6Q3IOlozmYp3sbZ6b2g+c3gx/7/IXMjEKP/LXkRVyvAzJqzSwo8rH/MFfZ5sTJ
 rKDMke70FROWm3tt1k/6V0zpzYUoKEk/KzjQP+oLxj5e/+7asmSG0DQoPYBmtFzngrfQ+N
 q3vF/RHaIYeZd4k9bBINfeTVp5tXss9+FldOX7a9FKPWcoXdbh5ner88i9bfUsNAn+3FQT
 c2Nn7+pVC2FC66TuNXLXfm4pT8iccg9V+2MsCKHqaERD6XEOeBz+n8jgbkssYz0go/IyZI
 9DgmY+AUVt2mXwX6lmGKqRqYJoyqDE2S24e4XzH/HZi27a+RcCqYyySbzhi8G5IWqiAsx/
 cvXz/+u5cOBb35FLakU7cB2EXLTPORme/GGFOhe3svu7sGAltdHtu62+fYC0Fbxa4IUQlO
 ZKFoBElrFAW5Hiaiud/ZGMTzpEds40IUkHXewwnOqdbwD8KfrE6zv1wP9eYrGGI7XEAw1C
 vVZobikT/Zv8rpC6vLOPtWX28uVne+b3uZRUzQs/w1wXOhpoiPHnaWeXX0Z+vg==
X-Stat-Signature: i7wo9m3ta4jter6mhjt4rijawwtoh966
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A66FD40005
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794925582-450383
X-HE-Meta: U2FsdGVkX18O+RIhNxQcebHuXe8GobKNVUk1Ocap+c5hkasuEqFzjky0/TOuTsphB7B+9ddkfSSLy68quyaNFwJv9T+mbJbK0NF2OBRD81VopnqXW20ZV1YrbcnIhqDB3N6eLPod8JIIj7DOj28vs8QUkprGfr0eeifed6ARSeofkK2Tyn2e6+81L8lPk0oELeuZYbw/e26FooF+g0jdyq5M97cLN+TdnbkhH4BzfrESzh8PwRwdKU3ttBN3RGuApZOM67ekA1t0Kl+BYu8CwfMildwQOk9zU0zD11Sex0mRFkMKV0eV2dWR13SUOWmwzpYOHDNY/FiA7hQJ9z5d2y+k57bMnyqA+fHyni4jF40KioR/R5rA1uYAT1zox7rv2U+bC0tr+GHUKAEC6xx368TYYxOHZM9oBs9kvt7wzYPF+nQ1u3Nv/zI0pHRCKs0b17WSgZuy3oV+GerRAtrZz0O3+9D8+4WewqRjqXRLroY0+oQSvgrngBSeyy+QGf1aJimk3QwEFpEptNU7ewGwMIAfh9JVarybFIU3fCJx4pwBxKQ6KX9+XQ5XGQf+c26FguGlBGMHNqcp/6Nf515afHWKB8it2D6gz7bzGsD2QnVaY0gZOz9r/RFZmNm1eVZviDUHsGOXqiMe8xRRTiv6dXhnFHWu5ijyzv4PtS15NjXcM+am89hvdOmDDPfk5/cx0QVXVly3d5X9b36hOF64aykAOps8zBvTC8ThqsF51Y6asmeHu0lRiY3xonkkGG3/XZbrNumULoDopXdcgA/axe4hNHNyy22fXU+LlxkD1rFhGyexfF69qtnHI3ToxIyQXZ0mNHnlDZDxNzvBC6kOtMqfVwIkJnxq632TIGtf0vyejiwqdNFcvJyvaiiA5lgdQ2pPvLenI18fWAOX3bsSp+ABHzD/HrcFkKcXp4b7GErx5LoIA7aa9gd2I6JeFSni+PCU+jqwXUFWFLiwMLJ
 OII2JqHN
 4U7vWA28MvF/EuYYzx2RgBlRHpYJOvqsjYABTmNGikoH9PploFkuB6jA3UWA0luMGxIGlzIVjaYu13nRmqg74fj9FCSD93/JoB3sX2kyZt+MqlOV46Ezmi/zC0fKbfjh+q0Hoyv8zGua/z1TnvtGfuntstWKrIAoDIs/djQQd5QEoLh4FXYppNhP1WWKaAgW2dbF5jNnNN717PnY7LCbKlbcD1q3P2lbSXmx4Q82TWj44TifVqEGAVgzXr0X1XTGIJzgJPfoRJRZMoJ5lgiimh1jseQBz7aYL8iy0Uxg+gNJcR/J5QcohT+KFU7G8tJef07ifL3wPJKzZzMEJWxArJ+mIeIDy8vDRmHfrlGpeWkRRgI4it3TZh/Lw254vd1meP75owF8xhIeIShRW1jFVl7GspKzeLB4Muq3tvaX2ADCaUacVBOd54RdrKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I accept the technical feedback. Silencing KCSAN on the whole dup_mm()
memcpy is too broad so I'm dropping this patch.

To be honest, I used AI to help draft the messages and I should have
mentioned that. I picked up this open syzbot bug because I genuinely
want to contribute to Linux and open source, and I chose a rare edge
case because I thought no one else would pick it.

A technical NACK is totally fine and I appreciate the review, but calling
a new contributor's attempt "slop" isn't really needed to say the fix
isn't good.

With respect,
Haris

