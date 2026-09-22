Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A78EC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9C36B00B2; Tue, 22 Sep 2026 11:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A406B00B3; Tue, 22 Sep 2026 11:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D046B00B4; Tue, 22 Sep 2026 11:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA7356B00B2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:46:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3974B12050D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:46:19 +0000 (UTC)
X-FDA: 85241824878.12.AE3E4EC
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 429E0A000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:46:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tKkS7HoU;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/G+x8EZ1Ezei3fqyde5MtjxhZdcvZ09vtY+lp4RtkI=;
	b=K3lIrT0qvVznoeS6kPvTBqRyrEqA/V23I89xvShBOn+fzv8cQIE/jMbBsLrcR3UENGkzIT
	gwZMUUcHyT+2eikqGNlrAo8gKXRf6F5wc0HSIR9Gt5TczZcb1Lcu4b2rpmhWjMYXz7GiWx
	nHZf4CR6n6O1V3+dDWLhtBun8WDjF78=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tKkS7HoU;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091977;
	b=0Laa2e1Pq55u4Y5L8413YyuGOcJrsoDInIjc+ILp4KVEh6hbk5dLxBITlxdbq212Ptk/1U
	6HqTAhCavVuX1qri3i3lbzxTXVKrs3MFTVzkNJRX0OBGkbYlt1hLDk0Ge+66LyFiQ1vk1k
	vqTTxa+UoCiCl0GF5nlgirbraSeiqRI=
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895eaf306cfso1329217b3.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790091976; x=1790696776; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e/G+x8EZ1Ezei3fqyde5MtjxhZdcvZ09vtY+lp4RtkI=;
        b=tKkS7HoUFAm2BKEirfwDgffd8DBv2CHqbjCnbvhPXS8USpHk9UH2fWVo6O/J4CwZjD
         LzNCq5J0VHP+w+1gsfyMmhe2zlLafRnbMoP8fx+KXCrXMogJ+FQAHDkSNEUC952NDBSw
         WYIDAKVmSPo1wjpisRlbDEns20sWpm19s9E60kcWTlIB/hVIRkwzCygKiHRCrJy0wl+q
         34QuKhc3RihJ0pG6Gubc0tcLuAdiXKmqqkUSM8li57TNdWenwOm0kwayio7DBTg4vPa6
         aWSYfWpXCw/YBAUQdh6uElQfaeMMs3gVPwdRkTfT8bKMnwIeveQCe0jiAvJYYuDhmIDA
         DCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091976; x=1790696776;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e/G+x8EZ1Ezei3fqyde5MtjxhZdcvZ09vtY+lp4RtkI=;
        b=EPO0EeK5nxB8IjCsafTbUpGqNtnjgwTWv/xTIv5CwNFajz5nrW5dBuCcPoXNI0Rg9y
         QRffiVKBwZpLJM2bbjai7MAFD/TeeBLBtb80zvbmT7o97eNuk1CpX8VWfMyFEYw/XADZ
         ivCNopOD0hQZk3KWWXXr4flqveEfUgWOybgflSEN6HZwOFwpBCsiJDmF36GIdm+EaR5n
         aX5MWzdrkmYLrk3qsekLwl/9ujg8bm0UheSKa66mjRuDs8Cs/FLuJq6WP2il7POD+zg9
         PDhmkyIjZ3XD7HB+J3XGIKLPzRpXCU2F27JCFC2jQNNxsuCfi7PiOi/WnQr7T8VfNTiN
         ldDw==
X-Forwarded-Encrypted: i=1; AKwUvByLSE3clLL/o+f6kvP1lR+2gnSCOYLhpeHG3DYUy+DF8d8ts49zyzx26h/+MiFWiRQcGZuo4XoYAA==@kvack.org
X-Gm-Message-State: AFuF++m+NVVX/n90ATkbswmlMx5CussX2T85ZGE5+k1SPyretXp5dVZT
	+r956t/Obdbti+V5j6NATVcO8UmmU3Df/Cd0+mpLC2buZ+dhGuAGPZdFLqLfYr2/HHw=
X-Gm-Gg: AYBFou0hvSv+6KyiZWd3dK4PzZUYcAgucDP7EC6O+Nrzew4jwZBhdC0YttgFTZZKRf2
	6CegcsMKIVMkJLq5YLtkhQUJC2pIldnZQJgYCV1dsDXrAFVxGMMtBdLEarrrwCsSG5KPvxkActD
	3+TgqvfPyfCmAeG0qY/mG+F3IWVrWi+xmtvPJz8cwaUsY12hiXVbyOXhPHLWbrJhOK3U4MONkpQ
	ZiB1WOsivzdEw5fOrwkIGxCkWiQKqTm9KbZiRXx9D1+FJkUBjRhgmffNkDK8+FbZyT7YrKDDTop
	UeBDwQUL/1x0YrpIOnvs+RauNxeH/pkNkS9vJaN+dz3U5siqd+C5J6p/FxgUKTki9X6dbMMrlCf
	U4yfQmsaduknJOFswW+sHyMTfxsrcSAC39V3LSj77APHseEl6yLpDAhCWt+c4hY8HF8fYzzm8y3
	ufMOF+wIld2+hMHLAm9dxeC7Nx7HkfE8Wqc33HE9kGoeMqWWriJXa3domPl9IoLFZwcqK5
X-Received: by 2002:a05:690c:4990:b0:871:cdc:eaa5 with SMTP id 00721157ae682-8973041de06mr56957107b3.1.1790091975385;
        Tue, 22 Sep 2026 08:46:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532e693f69bsm8080941cf.2.2026.09.22.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:46:14 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:46:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKixeYuuUKye7bL@cmpxchg.org>
References: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKZpJDpsavixjPx@cmpxchg.org>
 <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
X-Stat-Signature: uqumjqnu46zomgt6duthykuyz8ffndgx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 429E0A000B
X-HE-Tag: 1790091977-195100
X-HE-Meta: U2FsdGVkX19GOWLfRMCnfOCsc/G0f0/OB3p2wHGkPGL/wV+0Tc7Yr1fRNozSHmwczda7CbbpxBCv7X7Jm82uJeQ30E03UNC5iB0CCb+qwm5KtES0vTqiFTOzaZ+X+qtEmAVrEgfCVxfIgBO8Tfc4U0AFMKB65THMTTKe3Y8QhAAr1qWU8zM5cn3yCCo9hIX3fxvNkfzatsODBf3WrHFNeqS/X38mURXkLHPJUjISdqQ4kHjqEWdwrtwfdtP/idVm8RfQpuzy3wo9NQ4FJi0WjkiO5YuqqPMx4ET7nlQV6pLTHugqAuIhOMFjv9hAJB+PfJyToO0iFUmVuw75xZV5yGWyvZ59fWsUDqkHdLDjsVMP8sjAn6MVS/31QpQswuBsv6Kk7TSwLXnQ3mGta/CziTMlQBHXgVye7VT2fxKmG1Tu/2GA78Nts6avXDIvMvdA2kBt/WoQqHrSd0Sca25MMSY9lpcSr1IkP+mF5C9yAIQrq4t204AfEPuwdSPG8Vk7yERi77yavQXMf3dJ9l0XqV25wprbdxdLvrRv/wHkz2RHwbY/haM+QoJIyoOkg6NA2daEYeL527YgwANAEYSfakbaA6Q7X9nfydMqtlEMo8sXmeIH04knP/NWxHXmhuXGv140WorExcXvV4ymDNY5tagAXvDx75L7Xq10h9HQUZs1PRIgBID1eM0Rp5gBACd08BdS/+Kg+RvnphKuDYTEH2oRGXkJ+yxxXMWqia3xIccpEAMHa9rJ6DW6Javc6YHGxhpkUIavo7Ld9E2S//ZbcCcTLy261SH5sCtCpyDxEuCp7Okb3sFhMD4jupZjo8U85uNnzSGKCNH46ziZEUX0JSrFdZcZcKJbUtimO7c43XVUcxs/Os1s90ipqvWXZEvp0uVYUCWEc4ydVg4VMgGnOD3Zmyeep/odMtnpZmwAnNaYF1Z2mFpSnyNwF2khBbtZmal6SOrhwtTCQJJZiCZ
 fq3O2Dc2
 +OCs4NlGFFn/zF04gaVkqVa4cVQqwPBlySSKVL+tBJYSU4Ru9620UIf97w4pvfHxGal88kl3rpg8C3dSC+fI8EO2E9VjH6cRDtjjU96Q3Cc00ooAXmxNY1huNJHS3GpQHifE0BwXSrWCrlHLLYoBTXWZ4ZW0R/XxFMHh1UTPbpeySLs5+JIUwQh0XeYYe70T5s59wiodaARl0esZwh4uUXzLuIIEu9qKKpHzp/FnB+E2gm88omRc6qZS3cHJm3Y74V0cRqml5Eo9ZFCzNj0kHGb0mMFU0Qg5PeYlH/E80vv+PjQaumP/poyt8MVTE335nWqMC9to2stfwvBnwc4wKAQPBgdWcVazOPTeVgK7szowSFepgxwqmarUgeni8CmcuaRJIKIG9ayYkEZVzKYAynACYf34Hg+uservybAToW+uEo5R0XvQQeYGw+cH0c0iXhNpvZoAVmdKvYeEGpoV2Pth8o2hd/N7N1hI7d0Gsq4tOkaq3q+d1d482/yJSEANlB74nDeWV9AQZvPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:30:44AM -1000, Chris Li wrote:
> In Chinese we have this saying: don't apply things to others that you
> wouldn't want applied to yourself. Do you want to participate in a
> technical meeting at 1 AM?

The only thing I would like less is having somebody else make that
decision for me.

