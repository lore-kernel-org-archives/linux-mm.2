Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F853C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204AD6B00C5; Mon, 21 Sep 2026 08:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC486B00C9; Mon, 21 Sep 2026 08:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3A36B00D1; Mon, 21 Sep 2026 08:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA29E6B00C9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:53:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B648C1C0C41
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:53:07 +0000 (UTC)
X-FDA: 85237759614.11.39E3D11
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf26.hostedemail.com (Postfix) with ESMTP id D4FF5140011
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:53:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="LwDoIV/e";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789995185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jdk8bFx0tKHj9Yl5yPuBwHegOpkKYh3D6iyI0OsSHvo=;
	b=g6v6LttY3iBokNopmbC0bDs3K9evD1+DezhJnaSCeohrLqdbVdio2R6LWM0KIGmENeUJfe
	x+dACOJvenkMU6DRqqKDE7TJHAMSJw881BSnUWUFrXABFseU1zWMlrxwKqEFlrv+jRXifj
	mmKwRFnNwm0CyDiY4xKQdJ6yxqtHOfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789995185;
	b=AlkFUMe44XhoqgMuxb8w/tMVo+07OXCDBTPN+v4qh/Vg9bTnLWQlaowU3QG6gpr4exLA44
	vKzjf/PgiN5NueVTj5AIfy5/0bi3X0noXB/kZqiqnV/8YCsribSey1Ny4WEUHW87Fv1R8W
	OfYW9uJJQBoN+yWs3Q/ukdHgoMgmh2w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="LwDoIV/e";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcbe207so35754286d6.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789995185; x=1790599985; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jdk8bFx0tKHj9Yl5yPuBwHegOpkKYh3D6iyI0OsSHvo=;
        b=LwDoIV/e6diz8h2ygn/QRSkPk8z6H5MUnqHtmUzInhGgzvBVb6qLDonyFk6FprnMeV
         rezL+spTvSQzXVs33p3tyy780AwSnFEqjLvtFr7WAU0ha9h4fohkDqxVaWmEDQMfBMbe
         A+DzlTGRTJ1u0Mb82hYjQRoEDN1mjuaJmgkERnYVWyBxv/lmGVGps6xIAtZgUYdOXQyV
         zUN/u7tTyaVAwR8GcQnIXOFQQcHDCXU/sVuAqQE11KAGWlEH25sr0CS2+1G6xKUZyCSR
         ucp1KzD9WCa6R4DdJ5UI8UycFxguzOPiTQpLQRSRpIU7TY8895dQkk7RrBl2U9a7v4ZG
         bFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789995185; x=1790599985;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Jdk8bFx0tKHj9Yl5yPuBwHegOpkKYh3D6iyI0OsSHvo=;
        b=AlFzlmoOQzY5oX6AnCsQrr4vDJxWcxPLlG/IxUohDzvKiXXZHCKyqgEEJ3mjOOW8zW
         sega2ptyEUKdWaFOuFpXng4LkPU52tJ9raPwTzW5Y37XuPqb4MkppReJb5+Y43A9znEG
         PJwKE9zeskNxbsnRCnYuvxrcIvy+5WoZCG2t2nypShMf2M/CjZNSA8h+eo4o/sr2iK7Q
         ZE7RXeiudJ10doQIqQINAAvVaZzKvXiUCKQHOckeHtg68W33snNQ9Dj0N+senhl/TAnW
         qJc+j2DIq7KAXS3Om+m12nyOArjaqzPtwl+Wwni7SV8NTkSACLuCVFjDxwtpyt10XX0x
         T9VA==
X-Forwarded-Encrypted: i=1; AKwUvBx69YIYCSceczLOf6Hx3F8PEDfMvuqahelKQ0v4qp009O/LuUzUz41Jx9K+L3T7Zns/8LnS/QLViw==@kvack.org
X-Gm-Message-State: AFuF++nWNcjBPCQS+AmGS4x5RsWZLbK9fTQvHO/HE7VaJOyKFEq/Vx2S
	13MROiXsQ/NquisKFoHkB4FSbalvaTWb59uKe1+syAm3HMLfAkfj5KnGyZcoOh6kNnk=
X-Gm-Gg: AYBFou3b9vpdofapWxfjw9aCCiC40pK+kT4DMyUBdpkAQVykMCs2pK/dB0XsiewFbpp
	J6PMNqpjAEhFYdtetdZrqfmflUg9IpKE/QnXpwhQs5fk9XHGtH5NrUXZkoSwWajv18905vyy3u7
	dfel5/Y4DSzACuCTMJ2VJAIoFjn4JLrabdWsuoR22hf0yXOmrw4eQTTOjy/7lcKtWon2FjgEg8O
	X7Il4D6ayYsiCxFBbt4SL/le2+4xvUk1tUFH3jN8DB/G1d6L06NFDmb/+f+QWgdYvxWI5rXL7X/
	kdDihSoMnzWnaMvr4KTuntl9719gW7iB95jY9uLdArigQ7gDHQSeHckAhXn+m6qVrEVB/KQM+1s
	iffmw0+OevPhwgIL8EhrLWI7nkYYL3ESBeXpd4JYLVX1tJbxCvUFxJwE9JWj1IYEgtCTNNKn7J2
	QuQO+8nbhY/CHswuqgmqxNP+5cXmPqKGNRKp69rWsiZJ5x3HEUMZHKejw5O9bc4Lh3jkv8Es7Ig
	2hcyxhWW4Qr3+bkeNOCr2NLsunEIsvJBFsCDseyXRLlGBzf8J+BTyg=
X-Received: by 2002:a05:6214:5990:b0:912:517b:20e9 with SMTP id 6a1803df08f44-913fc969610mr4155346d6.49.1789995184825;
        Mon, 21 Sep 2026 05:53:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260a6267csm68171296d6.25.2026.09.21.05.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:53:04 -0700 (PDT)
Date: Mon, 21 Sep 2026 08:53:02 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Rik van Riel <riel@surriel.com>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
X-Stat-Signature: 3b7pedqpgqyfrsb9fyenabeuqjqiydx3
X-Rspam-User: 
X-Rspamd-Queue-Id: D4FF5140011
X-Rspamd-Server: rspam03
X-HE-Tag: 1789995185-929375
X-HE-Meta: U2FsdGVkX18vWMNstcX3e2M7JxnfLakQe5XJVVrL/RUqQSgp+pHxAxYIeZIE+leOBFF65VsdxtO+CCSG4s4fhUhEcWGFI0LKR1SaXMECf1OPVmQh6EaHn7NyT/Egby+DvRnqFDyTMYCaZvhjqWlobNyXENgrSBFDA0jfTf26AKQdhUy5WfSOMw3MF+OAwlLrOt3ILsVG6Zw0YzkPDeTQ1BAtR2ZZzxFB0OFvvPZkRhJmBDPaTu/A5qOdGkRJjtZaNxanveyaVzaRtx8/T17jfo6ZyBxEuJ83ViEuDIB3aW0nClFO1yiIKESaexIUCcBI03tA0Or3q2WN0d/UdjXS8KgN7mFhWx/RgB+SQQFo7bNBlIjypPyKGJ+EZeUiDuJRTKMf+2Dp+/EKmhT2Vj8lds2Qu0JU1740d9Nsf+Bz358A6PtCRKaQCLRzKyIHjDeRdupQw/Tf+peLMnbw2LroiJ9cd0ZxGc1gE4XBtWwWGqyFAdDXbJh2tegdhUMKdYZxlazQLbxOcCA1K0ydoLlPB4iBjQ8PHWWcQCFBgCfrbBRsyRcslYbemwYT1U0lWBPfaMetVK2YCu2Um26ln9Rn+J61XT+K7qplAiN0IwlXk/0Um+kOAi7Q58ghY/1FjlvSiELzGbYptkqaGFwdCibCBJrtMWMb5XzMGeNPwoZbGuy+eRCrKKjUnv349IM5DhM5Jggv507yT7l6JFfRtYVMzeZOAkMPr3/jnS+4VK6qbnLZpxzRbj52Q7ZZUVuWeznc4WQzomwGls9WdPciFV1uqslvpP4Sg3WH86BupfQtFkOwcQbXKuPIOwgeeJhUsfxIrVRkPTrw2dntvkzqrAPfs15CgFhGq3PeoVZr8EYmCjOXQBnLs0sZ5kzGc7O5PEteMPOmU/ukzjmUdF5fULLeskzZzYZUbp9pXDoaka+eqD+PX27dv4hnQ1yTvaDyVD/5Hj/XLZ/xDaUcy2+UeKO
 juhOaCjE
 QNjsFzP9J5hyN/K79nlAi+fQCTOYnXja9i1FKWNI31O4FSDYZyCzAvjTzXECc5wWw/J6le6qD6+2z8iMVrt9qek0HHtJO4WZz6ZvvQe8vbJSfkpR7Y3oRWDdYNR0/f/sLSQuSVf+GvHujiwhKNMsIsCVqvuM7GDKyd7nwQmE6bPF7ZiuCXermFwI3YhhyyIB3TgQQTdzShAagXtcTaSXQHEbaYneTjkiBNq554hJmE3oOv30VG5C7/04uQ8yVrt3OmKAyRFG9Abs10d/dB4gkwTmUXhdo9ee91v9XMgKXTgzJdAZdWNSPqGA9bh+xytC6/aiyEToT+WHmUz2DQHWyGVkhxIpAJGlLEtcHMm44yRrpAP31D57kTSjVo2E6bE5u0SUSlXoahNwTzZ+VVLTDzO9W8Lx31ueaC307h2wLWjwptVYokLJXT/TkYPMqYYcVTYUq0Z6Ab9uYitAa1S7RRT5BrO0CIrfTAvvpvCHJg0DtTayznOhtQO4BUTYoX2aV+D3ztto+S9xWPFtNm3LNAfUGUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 11:43:59PM -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 3:53 PM Gregory Price <gourry@gourry.net> wrote:
> 
> Let's start with the real question: on your fleet what is the max % of
> zswap memory compared to total RAM?
> 

You're asking me to predict the future.  Any number I give you today
will be wrong 3 seconds from now.

You can't know the compressibility of memory until after you compress
it, and requiring a user to predict the future by forcing them to limit
the total amount of workload compressibility does not scale with the
number of workloads of variable compressibility of data.

That should tell you that your model of reasoning about this issue is
ill-suited to address the problem.

~Gregory

