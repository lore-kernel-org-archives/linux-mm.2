Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72D8F9D0D8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9166B0088; Tue, 14 Apr 2026 17:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED00E6B0089; Tue, 14 Apr 2026 17:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF046B0092; Tue, 14 Apr 2026 17:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB7FF6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:38:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E01B140221
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:38:07 +0000 (UTC)
X-FDA: 84658474614.02.5A690CD
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B17E40007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:38:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UenZrEk4;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776202685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OB6pidPOLogYNyD7EEIfdqKqbTJQgvZ9at6gZ/qm2j0=;
	b=ygec+wFsn6nUtW6z9VwC05jPUqcqvr54ZkjXRmMOV8YB+IGiABGeAf5HCOF8mUGR9KwZfm
	uVVfWVktSE1bbAIPjrhZAfMfRw5exk5uCcXZJvN127RQ9AOsP4NrIL/2OIXWw/EV+TQn4E
	bov6Rt75KAeIjQKXS5IIhvgaV0eUGJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776202685; a=rsa-sha256;
	cv=none;
	b=hCG2QgjVUamL3h/T8NflZjY/+lOAQvJVoIox49UQgzzlGM7bADKdv0BjMwU0Wcqoumow7U
	MosKIMonfbOR7qlOWdH+8G98YnO2rcgzh8qaEOQUft517obV/R7U/mbfh4LCNdSMwtZRc2
	IrEhKYSh6FuJkuUs0ELHr5JX+GPMs3s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UenZrEk4;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63ELR0Iv2202154
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=OB6p
	idPOLogYNyD7EEIfdqKqbTJQgvZ9at6gZ/qm2j0=; b=UenZrEk46SZcHtFJ+Nb/
	fAr5m0bGK1fniVV7xmiFAY040zcT8vaHuwvuxVxJrMYbQ/zsRlyiKAxBEhoVHg0o
	6qwwUwYgH1AfiKYfzAnxuDCVaYVjtRtWW70Z+A4DcgesmW1x7yjUeBzDwCG+PlnN
	CwvWMCtVMNCc4LTK/Nr7dsBDSjiv43QXfAn+lmv02jmXdearK6k9/eFjW5J2slFu
	H4AwoG6CxV0JL4H8uDkYl61V+5TT1hbMUaz2d2SMV96nL7O9UVaQXJGGDrwa8eHw
	wQoPgrbOctjF9NwG/8osy/tOG/ldJv+/bMH0NL+ep2pzoH0QgHPCwIbWMMGZVtDY
	0A==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dh8588k09-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:38:03 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8acaea1ffe7so81677956d6.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776202683; x=1776807483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OB6pidPOLogYNyD7EEIfdqKqbTJQgvZ9at6gZ/qm2j0=;
        b=Ul7VSjQudNfGkuGEAmnDUAI6Fn1RZNq87E09C9HyxyOAmJ1u+UmFWADgFeTqzoAPQm
         q2mL9Lce2QSraOB/r5G+oIIJO4wH00P7xRY1yGRJwC9pGySncmzJ1+n11hr5jNSG/VR3
         XZs9YAWfAv4FhzIjqF9h5adAFe6Ha8xhSlPV7IK5hX9iHcShF/GLF4tpj5v/9wOj/gjY
         OvbPCsrzj0IynJc8zpBtQl4zxCW5i8n32zAd+nGFxzAm9f5dJe/QKw4UoIf8udyM2mXR
         bEdhKEOzrYVHbUzWYpF2jALiVjLhK21h0iLk9LrHHPpBeL6a6+nlWg4gj0spPwvJC5Wb
         3RPw==
X-Forwarded-Encrypted: i=1; AFNElJ/vU5B8WKcJcG+10l3CBShwvLovMyfZpz1kmTtFGcOIlUq0AK00EQN9Pc389hlmJ1IxAw7sJrbYMg==@kvack.org
X-Gm-Message-State: AOJu0Yzmqp9bH5Hg4CBHtxSZPbvhZ2tBlqLA0dBNWQyLteFtlhD+VX9S
	RVwfqASmryhYNOb3mybxUK6bLAlWxkdZVk6C8If4S6KeQ7BxH4wDu1EOYrjrWNRYBTN6Z75JK+Z
	cHoaAnLAiL1JTZW5W6ULVV0l8enkUYmUpqj7n0nRl9FO+4woa
X-Gm-Gg: AeBDieuYZl3tpmWBLYDXjI4xc9VcIubtPL7iWwIRy7Hn4rpMKQexm1NK7Lov5LPD73s
	YlPJqo4Ovk0wo1uK3mPmwFsd8BeJZKKpUdUJzzcScJuhZbJl1mTaFYJ9ZsX2sypyJS2M68hjfpd
	ZfceoZkzH9CPtLd3u0CVxcqqFo008qwOjjWBG8dyejargCIXRrQpaYYGq1DyqBGhP2Ss/+VyM5Q
	7iYJ9yYAHSVsh3mvT10GxcLrkCRxLjdLNac/fS6233IKJFpOIJELXg17Bl4TCONIir684zuipRR
	XTT5GXvFMoOfSIoiSC7WjkE48wmkmSBK/pI//N9XkrQMLtBiGIpai5Ffm8RXM0r72AzEkC6KZxh
	6Z51fLT4woLi6uRoIh1fuYDPnxfuKF7ma6KsqHLCUT3pQoNL06rwwLO92Cym7Ba6HN05FzDI=
X-Received: by 2002:a05:6214:4905:b0:89a:1364:1027 with SMTP id 6a1803df08f44-8ac8617efafmr306359306d6.14.1776202683044;
        Tue, 14 Apr 2026 14:38:03 -0700 (PDT)
X-Received: by 2002:a05:6214:4905:b0:89a:1364:1027 with SMTP id 6a1803df08f44-8ac8617efafmr306358966d6.14.1776202682633;
        Tue, 14 Apr 2026 14:38:02 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84cb0474sm132012676d6.40.2026.04.14.14.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 14:38:02 -0700 (PDT)
Message-ID: <5c1205ec-cbcc-4976-85d3-0643083bfbba@columbia.edu>
Date: Tue, 14 Apr 2026 17:38:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
To: Lorenzo Stoakes <ljs@kernel.org>, John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Gregory Price
 <gourry@gourry.net>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        lsf-pc@lists.linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@kernel.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Chen Ridong <chenridong@huaweicloud.com>,
        Emil Tsalapatis <emil@etsalapatis.com>,
        Alexei Starovoitov <ast@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
        Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>,
        Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>,
        David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        wangzicheng <wangzicheng@honor.com>,
        "T . J . Mercier" <tjmercier@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
 <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
 <acX8_XMQYA0-NGUW@casper.infradead.org>
 <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
 <70fd648a-efa1-465a-8e6a-51411dfd50b8@nvidia.com> <adddpxFfWIO9a2Ih@lucifer>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <adddpxFfWIO9a2Ih@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NtfhtcdJ c=1 sm=1 tr=0 ts=69deb3bb cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=eZBIlsz9hca5io5qbP0A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: 4seeixibze56momM7QExCewJ0nAwl3O5
X-Proofpoint-ORIG-GUID: 4seeixibze56momM7QExCewJ0nAwl3O5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDIwMiBTYWx0ZWRfX5ysfjp4vA0pI
 jxS4EhlPsnocJ6HT6+bfGTT4tsYaxoUE7uOtcIyW/ULlGJYVki5NNBTTVE9AbEez9JnqdG/pSco
 PgN2O1CDmfqeRbXWIRB7vjCgpeO1GW8vPGRRwl/XeiDtNjfft/X9a5tT2W4zUSy9oCOT3dHbtIG
 UcqtWUtHSA17S4TKWfO6EZthginQggYB9TNcam7WEfKlWSG7Q8dmuOFA/5xzDIikgd5nxcnl/uU
 akOkOCOFwnf/6f+2IchXnBB9JV0yBukCoTIEMKx03RkRB1ZCZ6Q6sbG6iFCeUsRTMLV/cF6cOy/
 hLc5RbMoApMKX6QJcZ9zQvqPEDx/7YewUJAzcrdmBxeBnt39I+xZfp+Tu9VcptdjymKYUJBqtdS
 EHOGorVull3MX5I7M3RAY4UWmVR867EEraE3/w3TtXhtf/wsDSb4XeZX2JuEmcLE0WPMYQPbh0d
 +w0isowyCBy+v6ZdirQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11759
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=10 spamscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=10 priorityscore=1501 bulkscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140202
X-Rspamd-Server: rspam12
X-Stat-Signature: 7koufb1g4zo5qt89zc9tenac9qn86wou
X-Rspamd-Queue-Id: 0B17E40007
X-Rspam-User: 
X-HE-Tag: 1776202684-91898
X-HE-Meta: U2FsdGVkX1+Y3rTDgm3sSTA8LjEwD08F5Fk3KQS9B2itV2hst2y049nr2hvjY1fwxwOS0uxnZ6c1oMFJof+vC2KMNc8jL0lqO3BJXlUErJ2Goc9A6GrqXp6fLTdD6mBRU0kTtL7z0acEMNAmNCmyUX/KPsKNPl9qTxXAeO7b14mqw1av7THX22esGizSnjkjtvuvj34op7wYZoXMkML0fOnwVv8/xu72kEaXD+uJcmdNSirRPi6PDx+u6qGDheWs2ywO71MlOKqEZ5Kr1UvPaVmsSxLblOgozXR5RazS6WmRQgvwjx7L1MghAN/RZ5AGI8d2dEAA+ZJGVu6Y/YPHJrBkPkj/LJ6K/bGY+lt+Bsl7N6ic5wqiHUZXYHoRhfR6yp4IuxuO7dDr9a+d0dc5LTUCflsSCU6unnyphIfRSoOIoOt0R+GpF4+s9KNnGtK+bwWCxfJRJAyICvNrWlk2VUiQ+4jHubSOiN2VNK0vgWu4/X+IjiSzKxIBCG4WgBWhszfV4+3HZUc+GkSzyV2o0NVOkRvbtP9u//J6minLR1ZBEWWHfeps2Lr9BeD4RTMc94jez6Dw8c/5oiXjnfudOHKb3VuOgAgTfhc0WjtygBabDW/DblkfFu01xWOWeCx43O0ajMd3oCkysQunT+AVFP4jJLmir7MmD4957J7cvnM+Gjk/65qXoW8Txk0b+mvLuzrHRDDQQBHsSYF/mFSGLHXT62nx6KstvEP6M/nDSUB6TtICTVgY+cbYE4PecIU5/8wn4YYyRkD7LdJ61r4r087Nc0qAt4nAwMSUMk+wPvT2hErpWsRfBp49bbARyZexSO8r8Xe8tG4pw18nNw4y3U+4JJ8MLvDDgGUDoPAcJOVF3wUv+kfic0hQa6WUOehRinIpRJbk5c4xmfQsBgRvV01RAEddUXh6lldEYEbT+LihWcXKvbnRiTp8SgzF5RFG/Wxv9G6Vrm/h9BeYNEu
 rpQczCw5
 WPqCvlNdvGvI+i+3lYxVDQ6t/adxLE3zU/i52HD1ilVdnaIkKwhxJMSuAZApEwfh5+uJBoaD8wB5LR26sl75RMJCmIo00Eu9K0O7GXHwQFFyt0lFpCgMUEecsMFWVMnfo0Key4EwJ4vjYDBlI/3ulUkCiUzF05NJ9JIi0FfO+GZknfzy4FEWpv2I0KJ0K78IZgAZYv7zuep9J++Opnbvh0Vcrp9lniRhflU0CTQyvJNYcWazNEPLZnNB9CVofimVrY2sw+qh7Tds0BFXlcMWR9SK43WR3GyjJzSPWvE8Zt71lCFjEL1nczAOfOUnbv9/HeWwiUHN1fYdHfO043k7nUuD3WU3i180xVRbMEWXomrBrhAW4W7smLglfJOxxeDDLcmB42jyCO4PapE6RbBsE+1C1OqFRC4AtBTBauyYwUnxwWijeSkxgCxceWOb5q+qdtLInNJ2a0smMiUdhpVDUwci1Nq/mIPwO+w9yz7Zk0m+AxjSf2xjSEbwFt10ZhOyQzSkbltXmprs5EEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 4:22 AM, Lorenzo Stoakes wrote:
> Yes, thanks for that, it's interesting!
> 
> But I would say for now we need to defer any consideration of bpf being a
> thing until we actually get things into shape in terms of improving and
> modularising the existing reclaim mechanisms.
> 
> mm has been far too keen to take features without paying down technical
> debt first and it's been very costly, so before anything else, we must
> ensure that reclaim is both long-term maintainable and maintained.
>

Completely agreed that cleanup is necessary and modularization is a big step
towards that. I do think it makes sense to think about what eBPF would look
like as part of that future though. It would be a shame to do all of that
modularization work, then decide to integrate eBPF later on and realize that
we need major changes to make that happen (but, given a well-designed
interface, I think that's unlikely to be a significant issue).

> In terms of reclaim bpf as a concept in general - reclaim is so very
> sensitive to even minor changes, and I fear that people might find
> something that appears to dramatically improve matters in one scenario, but
> end up with an unusable system in another.

That concern is precisely why we implemented per-cgroup policies. We found
that running each application with a policy that works best for it yielded
greater overall performance. System-wide policies may need something more
generic, but if you can make them more granular, you can specialize more
without running into such issues. This was simple enough to do given that
the LRU lists are already per-memcg, and eBPF (is about to) support
per-cgroup struct_ops programs.

> A bad sched_ext implementation might result in poor responsiveness, but a
> bad reclaim_ext implementation might result in a soft-locked system, and I
> fear that it might be quite easy to do that.

Anecdotally, having implemented about a dozen policies across dozens of
workloads, we never ran into a soft-lockup. That's not a guarantee that it
can't happen, but with a properly implemented fallback/watchdog to ensure
that pages actually get reclaimed as necessary, this should be manageable.
sched_ext actually implements such a watchdog to kick out misbehaving eBPF
schedulers.

> In any case, we can look at all that once we are in a better place with
> reclaim, which Shakeel's proposal focuses on and I'm very much in favour
> of! :)
>
> Cheers, Lorenzo
> 


