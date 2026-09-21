Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA37C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 17:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC226B00C2; Mon, 21 Sep 2026 13:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA38B6B00C3; Mon, 21 Sep 2026 13:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1EF6B00C5; Mon, 21 Sep 2026 13:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC696B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:05:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 398E7A5666
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:05:11 +0000 (UTC)
X-FDA: 85238394822.24.492AD05
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8361E80012
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:05:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=N80XRz5N;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790010309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7LCENNPwU2GeUQBgdonqhl0jI5d3t/m3wn6hI3Pq7k=;
	b=GO7tTKWcqsblFzlhHEUYtXmX68RYgS2eM9CAL8l5UAiOe5Xkv5Pd69XL3mCSx1wijjjQbe
	7evYq4utLUYzjrHFofHnguz2uCSnNvb7XHFEMG/K41Ml2PJAaB9NSsJdBGy0c6HGGiquzU
	gi7IFqB2WNg0c1IWGPUxoGGL1aFR78w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790010309;
	b=pqgcJVGTLnPiIMnqTDeyynAJuK616yRei4rlyFFdfa5Ztq/IE7iOj3R81++lLtBqjwffg8
	bZQnqdZar01oFihvei/khsdPwZjKXPGCRON3nKOiiczFILP/ws+5CO635pC0eA9wsAwwZG
	tB2COMfAHH6zXrZWiO71tbd/0ZUsKZA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=N80XRz5N;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530280b8234so16103291cf.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790010309; x=1790615109; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v7LCENNPwU2GeUQBgdonqhl0jI5d3t/m3wn6hI3Pq7k=;
        b=N80XRz5NtY+dH3OJz/AEGU1zE2yBwGfyMuEYYKxNqroKQ8M+5shp9fgMN0GS1XTlWW
         CAk+d9zsCcDfyAuOQFBfxkAprp1HnrFE8WZ4Epc1dghLY/JpyLP8vik14uYn/DTnXAod
         WTSE/EHHOtApX6vBMfHE62N9+MVz/KkEekoiTTTDUdUKy1D86naxiSFWyGqEQpO64Vr2
         giqTb9J9VCTmpmmOzxRbc88BihOnH7q50KtShgb2sxNK/oNJILo11aU3ea7leMl7A4Ow
         Lknrc8ztDhgBnk8oif//8uPagXke9q2XxoRcw49VTprmDz2CnTWNjJbuOF/o4HLJ4qJP
         93LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790010309; x=1790615109;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v7LCENNPwU2GeUQBgdonqhl0jI5d3t/m3wn6hI3Pq7k=;
        b=DeWt2jIjJIeNEHTSkbOcvOzeNl0E8abPlQJuRL7F6PdUqykRzKLWSzgNWvX4tLrn09
         R7ulj6uVd6uCrJgwuzxrDHQSvYiTiDmDw7Gt/JqMEtVcicqSUc09IX9UfOfgpZ3e15k/
         UhylH62Kdaw2D1CAyCOJ4IrED1BuqsvDWqYX5GZJc0sLgFid62bB88OjIX+dQd35NB9J
         0S03/4aUYLBylt7bbIDIoCvU6hNJudiafDNFAGD/mSMZXkoZ3IibKa3Dn/D/yLE+ZAT2
         NE+IkW55mwSK/6gpZTGBnwAWyOfAOno6YzhJmsCV1RjJ/QqWA6bHcFL2ryJSLhmppZlE
         kgNg==
X-Gm-Message-State: AFuF++mhMvnBT24toW2NdLhly0WXiMtAqCQ6DBKmHhj0/nWoxLxGfsky
	05xekuhIWOl0InwIAm4cFZmOivQzN96MmSWdDEpYHFEkCK30qv+gwud/ttJn8+vJETA=
X-Gm-Gg: AYBFou1iNnKZ+d7hd1qeIj5W2h5Prn0Oqb0HsvvMhPH9HriZKaClOF/2YRs+krB7VYz
	q7vLjSHC+ZUQuOH9RAWtznPZcdnXCd3yIB47mgZeEA1LKVtDctMJ2z04gcpxPbq7xjsDvkOsg5P
	faYsCk3rqBTXiMzmHQuxX6qR9rKPXr5fPC7ONWRrle9QAqSHrQmuQWcwyLBLb9BWdzfi3nSvTBj
	KEEVkYuOZ+VfbHGfwBMUtL5dVVNy82epKT9JgNm8WsA2XxFBRX3imFKbcGvrM4/AvN1V20gQZK4
	x0HRrHOdL5m8KbXJjqKU8a49s7egtVnntHhjUfVx3M8VhSa5Axjt+srStneDfPZntObWqMqiMnO
	A6wY3iwGmhFjhZdD65WfzSUYaONgOCRJa10U1vtl19+DjdBk9yA61+pFMzqE8G9QxIdWMQVW1pL
	7kvSP2r0PXlryGl864fcvMEbE4GONBXuk3EhX9tNcpr+bVKm/8okDxnhbWWsBhWxGjLMGGPT6uO
	kXJk8uuUWYu
X-Received: by 2002:ac8:7d43:0:b0:530:f84c:f02b with SMTP id d75a77b69052e-532db76f02amr3607851cf.1.1790010308696;
        Mon, 21 Sep 2026 10:05:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([152.186.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532db6b5651sm1983721cf.18.2026.09.21.10.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 10:05:08 -0700 (PDT)
Date: Mon, 21 Sep 2026 13:04:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Message-ID: <arFjYiMbWf4ihrCu@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
 <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
 <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ezbki55k8ctfgksxb1aaoix1wtoqmb4y
X-Rspamd-Queue-Id: 8361E80012
X-HE-Tag: 1790010309-303996
X-HE-Meta: U2FsdGVkX1/h2eVoufTal/Jw1VTCVNPt3x+7/rgOz+f78fHjBXsyaqxJXn9HvUJuF+kx92gAnyjZvcB3CW7b6uiIfOSqi9HSvHExCDhyK/33lU1QwsBqog4BMvLmnbs5nBq4ff+N/L1m8EfFYn9RBCxyB5asy4hgZ18BCJ0IaI1LIUXnNmWiiIBi1u4Mg6b4NBuhHG9GhLRnv3Dl7WJfn8agLCUVmEz56eP78zLwjsa+XWJAuRp9RRBsbF7/kr5K6SnHRsVoMyXE0zp6eSkjP5xT71oJ5lpnK2BSUJQiqU1zy6T7UfWT75An56uHpYpvaIAE3R9aKyfgY0UJ/w97csku60B7P5zZui0ANtJFbXCYP/I7AGYz0BNv38Ylf6b9U7QgbVgH5RwVX/JOSVz42QNDGbrkS80BAsnU/TaiTcPqbzXMst/aL45y+FmtIyAzx3WCsSNVQM8ni1y9ntw0x5H5VzvGohO1VGUBuQUuW3yKluZfCEomylqRqSDPAwKXYbuCXdfA6yCau2U9Eglk/QoL0b/DoHVhr1rs+XH5i++ttWkoVUO+iOdUYi4wh4ZVozzBt9l5tAVUcQ4OjGlciPjsMtN4CLiqnoZCTXtNXDCKSstMnOP53AXOg6oN7+Iqyj4kTWnK97mx6RhFFSNHNwslNEtjDGH/vjQLBHkkxO40rQHlSiOODJhtUf5Uq3Toky5olPf6BrIN8ZbJPnXgEqu0u2O+r7g47n8K+8xt1thEjFAKLOmKYbbMIyDMRfuBG2k82bHMpUJjyBS5iTGngXkYCb6TSqxKAMM6M6YY/XIWzEpp2WHE/L8DlBv4JO2ByPN2h+G/GoE4sPKfNHPOvFzf5C9ZLEdKYasPgJd6ufCDiM0i91YFPCkdyrurx5+HD83cgshZOHyXj3njp/c6w7OFPxCZpjNfNAWXdq2oKT8b78vuZhp5NOiq4pZyRibqn6CHpy/UG2ksAp8sNJS
 6uJBkIYF
 Nf4tT6BvPJL6dOiXvyUAgqfVREXZc4Ci5YHzBxANRyK+0zj3WE7adynW2A+/I1KsvzWkrRYpkEZoTVcqvu9DLXj8h/hlib2KFRtIxl1B5VJ6lxwijX/8k05kZrWi1OCbPaS5aNVyaGB9Y0wReZvo5idCAUGvCiqiwlD4HJkhLH1yOJX8AkpmPTH+0PuJH1EEUssJl0Cq+72qcDUNJldtHP3/jwZb3Uw2FYec2sM68EfFUpkok3/UAJh0HGUEi7KUCE6VCPLvnXQUmmJ841JKTDc7CBVYiVYDgNN8S2C/yVha1GLZY8nE1z988vxozrJkALIZpCfUz9mixVo+6fsXLBhvPOc7nJNgiRPpPSMG0a++qQFTSU79whTFBCZdxwz85ClHePW+URzmM5iMccVg+cLDcDly/J7H/XkLC0xkZuP3VB5L5iV7tbw9a1DHXalxDGT5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:38:57PM -0400, Gregory Price wrote:
> On Mon, Sep 21, 2026 at 12:18:12PM -0400, Zi Yan wrote:
> NOFALLBACK
>   0  :  [0]
>   1  :  [1]
>   2  :  [2]

NOFALLBACK for a private node should be empty, sorry:

  0  :  [0]
  1  :  [1]
  2  :  []

if you attempt alloc(private_node, GFP_THISNODE) without selecting the
private zonelist, your allocation should fail.

But this is more discussion for the private node series.

