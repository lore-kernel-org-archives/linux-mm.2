Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC110606A6BE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KVyteKjX
Received: by kanga.kvack.org (Postfix)
	id DBA7F6B05B5; Thu, 26 Nov 2026 15:45:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B046B05B6; Thu, 26 Nov 2026 15:45:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32F46B05B7; Thu, 26 Nov 2026 15:45:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50CDF6B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:45:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAAB716011B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:45:56 +0000 (UTC)
X-FDA: 85478451912.02.B9A7EC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00FC51C000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:45:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVyteKjX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795725955;
	b=Z2COHsxz3u0TQl3g/O2tOsU+DHO82liIQaebvh9ahyDbtzAXlfaYMh2o2BxqO7ti8V2FRS
	D0t0j/G088Dgtke7YpzQ/UJgGTZOVvShEn3qVf4rnsDeCqFcqy4qVD2j0txImP/5Q2L5Xl
	pFqzUyQAxPacsKlMlLbdx3v7lgS5/Ns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795725955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdqUDcmfoR3VJWIc2NbNNrZHmtzY94+puoQPf5oM6wg=;
	b=eJMD6Ls0J3dbsWY9VMH+/fVDjuuOxBaZM0bLww7MwBbZy/soPi0lLfudIWfE91L4RtWmFN
	27CDpECVTEz/pABPoihl7sduHQ4K2XOzZziHtMvPnzrS+DTgjMlVxMQFYk1jgiWWHTcVnc
	eW7xO0NGYaFTAi5DW9NJj0PWi6g4u7I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVyteKjX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E347540AB0;
	Thu, 26 Nov 2026 20:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118741F00896;
	Thu, 26 Nov 2026 20:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795725953;
	bh=LdqUDcmfoR3VJWIc2NbNNrZHmtzY94+puoQPf5oM6wg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KVyteKjXGDcCUpwC5xC5unxF2Q12OHXEwwIl3Xu8YhDL3mIPnsG7rq25tDnCuifhl
	 pkZm+MwrXRrrdvAdzo4hkMI5x3uB9x/TosXo45GOlAQMVGnULAGx5qyMeszOCSupZb
	 nZwcDxdqQ/3wa3Ej9YhUL11mqUHEoUc93elW9t63Adx00H2BD7Lwm9Y2NG84y6ptqQ
	 7eDn26PKTROt7IJupJpBxIdHvPNTkGFpBfEmsdiKhZjhHvvghtIO9YQ1pVr4kovd+G
	 6cEVUuGqBDFETtyZewIwEs021gm2BO0k0P+5sLBQBlioEYI6cgsyO5RNWit/AVDFDD
	 niLGmeq1hx4bQ==
Message-ID: <3a44dbfb-265f-4749-b411-9491a0bcf8c0@kernel.org>
Date: Thu, 26 Nov 2026 21:45:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Harry Yoo <harry@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 daniel@iogearbox.net, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>,
 Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation>
 <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
 <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com>
 <20261126094403.GA49833@noisy.programming.kicks-ass.net>
 <aecebb39-47c9-4b0f-a076-ac0ddc7724d9@kernel.org>
 <DN5FM9P3X2P0.2IFD5DFBRELP1@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DN5FM9P3X2P0.2IFD5DFBRELP1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00FC51C000C
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 8t3n1oanhi9hwq66o6q9co7gij8t5xtf
X-HE-Tag: 1795725954-848143
X-HE-Meta: U2FsdGVkX1/xGYMY1xHAQf/4OqfOkMl3ifaNBrme7/IUdHIMSCJaCqC4fWTLaFA1/edCBZ8CIMj9L3f0tnW+jI6V53EXNPLknwAXF8zNG2EoWv0CG3hs3knKsqQ0cFghCIhk/m4j5dOSGM2q3Gmx9j1z+5oOMnjAnqWjin3nGPsfXS9zW/LXCP3I3povGtdonQOIvoiPBVHIRK8aQnaHnkFPNkzOFvcT5KD1SlgePaAX2bR/adIbmY085SofhQYYyAaemF8JP5pquNcaBxDSMU0kCdRgcnAk/E1TWYZIE3EvVR0Vt4Gqv053b0KjrZNQPZHpVUH65PlkENJkYiOfQNYQIP62oJx81YkGv3ToqeD2jTi/j2hOslFAtiPVg+3IHIjLNh7iiO7HupQD0KyUTgE8Vjlze3ZBziD0pafzLpQpeKrjuZHuy80GWmQmcyoJJwInbRaFxIE90rLBLjwv9r7Prjy4GUdJhlvgWgIWgMsRNVZ05ekFKnSywYxcOdL7S7GVGq/KcjfLgSSUCDX8rdIbfsRD4S5u9MlGziFTnLXBMuhmqqOWP9ikFfjkS26Lemd9v+y82uUSrq/1ENei8fvFKcIhYZ92zG8enNTVI8Sb0Hyy4f+9dtOBb/C4HuctYlTZi2Sx0Xi9XgcrZ5NotN4YmW3MHHsj7QvngP7dvWDLSIHqfaqbN35eIdoI2J0TQl49r5oCo2YxRFz7n+PZC3ZkD/lkSKRaCHzjHypyfY3ThwUnLalI7xfFgq6mZMNoqLqGgYXBuyB2UGpo7ZKZtOspP9VDz0smjFUaEantbl52gnN/YXYBA+HDNQHKGrGiS1sy9hGV0pm7OOeZySLoujapy2fwXg2XOzmr3zFAzsQZ/3wOvAEuVc+GXenBiMUyt30Gqg7CJHINhpd2UjFiL0yCSuqOzjOUXOCUYsevvgrjPSFJsLsViq/0YUoIIE9qhfMrtGdK2EPSSEDJgEo
 BjCZieOG
 uMxcaiMmK3pzp6o3W25hA49lSzYPfY4K+KyllljK1zxbkAIoRGVP3tkg7Zb2+aO4V7TXgJ69JX6GoO8lj6KgUFX0nCuL0gQM53lrhyWxVVoRLskE3dnItnvNaUHOQKFXZFGoxfPzhV8T/7RlF/PR2YL+tJFI4X1OKlIR7pz/7OGlvXzNBsHtGHG+ecTp1RgJZBrY/rqdeD8qPXF5HzDJ4UUuneFVXkcWw9tWNu8Go4FCyP8ch+a5DjiByUDN08+wRfSO62KKNlqP57SI9IsBYmtbyea4qmzcLbS62oA8t0AFiNFKvFQCfr7i+bhuo3OOkwfu70y60sSt4KJPI7aI3a6hLPLbOFT0eY/8c8J9BMlpAhH+87eaSAquvfB74uxQ7Uuaum9CpG0FRShi8xbKkKpJzmV0fItpGzRrlThxFyvrg/z06tALe82+yiR15Qq0+L/0SZq6F0wdbWTg2PuEZFUU/3hEQrycmm9QCoZr41W+xWzMarFIOmcT3mJvJ04NZbRujn2b4ZrbFHkvtz37TNrob2ISMZvGJoSq7yoFBNd5iDha3aFgRmySwKiah0uSG3jMdp5EZlEB9/TFNEKfBYAM7UKyzd7GLQ76DlhVSeDIU6wUQ7s0aoWb9RJubmtFINfwWuDt6a2MmyfHvWXSP/Gzh+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 21:40, Alexei Starovoitov wrote:
> On Thu, Nov 26, 2026 at 01:46 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>> This is all just way too complicated and shaky, sorry to say it.
> 
> Which part?

kmalloc_nolock :)

> I don't see any new concepts of failure modes vs existing code.

I hope we can sort out the rough edges.

-- 
Cheers,

David

