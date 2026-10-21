Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B4E606A322
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Jv7IJfzn
Received: by kanga.kvack.org (Postfix)
	id BD7A46B05A5; Tue, 20 Oct 2026 22:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88E46B05A6; Tue, 20 Oct 2026 22:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50BA6B05A7; Tue, 20 Oct 2026 22:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 816FB6B05A5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:26:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E66CC40464
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:26:30 +0000 (UTC)
X-FDA: 85345044540.26.38D8853
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F00A120006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:26:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jv7IJfzn;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792549589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDdiu7ls9XDQIfTHarLgal/BKccCKhlDZU1D6BhXGx0=;
	b=NuivTQ0xW1NAlzs0iLNXRzxn0HMGfXM01bAnyhJtqZpzacvJo0PZrQoFTLquaZiLYgYcFp
	u46CIUKGyJjhlEjzMVw0M0RB1JG0qfsw/G57BZfqsfJiaUfuiW95nqTO6uYkGyyVJzB3+K
	sVeF6CZDTuVKRtlq1mTwp2pcBGuh/5c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jv7IJfzn;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792549589;
	b=lsyLN2GqPbQ2PSOHfmzVixWzmV0J7s85gS/WZ3KW8stI4hXlJ9hLM1tZWU9ofYVDTbguZu
	5+JD3VW/mHEljeKoHd4ZYET8GG/QIQdc3Lnbw1JFksjpS7Cd4Nm79mYTycr+XbM6NF584G
	X0WxLVw4/1r9tuKLKgIafDW+vZvEqFY=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5350d9ea106so3477661cf.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792549588; x=1793154388; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qDdiu7ls9XDQIfTHarLgal/BKccCKhlDZU1D6BhXGx0=;
        b=Jv7IJfznv/KghHYjPdUd8/gdaWG4nu7Z0gAnvsLCBk+7zCA62js6VknHGP0qHsppIB
         uEvhtYyeK9zoMcIXEC7Lob5F6TpTpUaV4ZD+EYkn4ooUbmvRO7WR6TaUhf6tUGjqZWB8
         DIdK2bcl7FfGrQNJl7TgQ3N4lRKP0U5zxnHRSCznvLRsW4/7KJhuMcP2bhWt3zcfx13a
         8Kjy4hoX2M/pJ4QZAPkAYpAF0I+vsfNp2T/ap6MJYdH6QlFXrWhR3IofmWZcaP0+zS84
         /rFfklN3VqMTRtTXrXzMvduSPfhXzmALB4PB5D14PkPC8awKoUIrEjBJPVZ0uVzflcBS
         XLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792549588; x=1793154388;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qDdiu7ls9XDQIfTHarLgal/BKccCKhlDZU1D6BhXGx0=;
        b=XA1DyVh4/a7pNN8Bk0TGNmV5RuWJQTPshzmS6dUUWpAc09s0TjEWfF4062iE6ph9VQ
         gVDb3lhr6GwfnPj4SsCA0iNHBnGkkLbW4O25Asr1E87jGeBlWHwWmsWscuFQRWW4IQ56
         EB0IptkQyy0fxQ5XLiOycx8bB/8hhXw26uynZBS5lqVQ7CpjRdE4+b29nuUcpGpjAUUq
         0LYT7Hd2gu3tbHMUDs6zLsCHQpiGTOJl+RiWiGTJNxeRH9x8k8VNBdnzsLsdRJaWhMXU
         0ZD0IPaB0R9NZvIPWYbiGTEU4gKdGblHYiqc5hEX/wS3VEQPAPz9I+3Xsp78TPPKbVgQ
         hY3g==
X-Forwarded-Encrypted: i=1; AKwUvByqEXnP/IZp7QdlDExTnCqAvf2wnmlTXJHm4cIhYL13winsuKcOExqKee/sTLzQb/obWgXxVpONSw==@kvack.org
X-Gm-Message-State: AFq9FYLcQQo9Z8teZ6EZMpI2Z0CVZvSYzlyCPs+nlXNXU2/QtiADIiZg
	zCTX/IuuWZwKVa1nUVv4Oj2cMaidvpqvPHTHNRIBUbx8MEqg0yTRlwbUGwyJxcZodBE=
X-Gm-Gg: AYBFou1FLwslje80wqChu/4FIRbiKu7bNyyCYZaUQOdZMyC2sQes9CHBBl7TsQc3ry2
	R0sRONUNAdECbiVvlhxGYs9LpxO9gA4hbch2h3qGlHmzQahgDvs1SESBUFqcDXnGF0IxxoFMbdW
	v26gqJCIAPk+umXvg2JFedrCzcSUiQuOvLUhPPxh1ghi/nWy0M+c6nLbTIb12RDxqcFDIBzy3W5
	GUlInoXEvNPPp721JyJiE459M+CHsKJl9Yqg/9KHNlZeZDJOliwukgMcahcAGRcDRVLvblEO4An
	7D45HGY/7HQihFTAgMj0iGmy+KCTQFc/PEvDfDOWiOb0KlWav/mft14pkIUQ0Y5ZobGia4vNX2+
	W5FgyzjQsADRoMJxCDrtJlXr0XCUYt5nJcBiwAZc8xmclbmANW6VNWfdAaYET+LRRqboJcANAu9
	FVk4/2MyXfsMc8u1ldH8KTny0L+cliAlndali9RR9nv36DVSGienbWdKk7+36Nky6i/BKuehXBm
	UzfEGbIDOug7b/4rUx0T2SZjOaf9YOeY09NSIJNJRthDZLF9g9KIwmVtDSvVmyKnoXFTGh2bSeK
	bqDKAS2Jt5bEay4vWvglqWZh9eA=
X-Received: by 2002:a05:622a:1248:b0:535:a5f8:a5c2 with SMTP id d75a77b69052e-5369b8a4bc2mr10226291cf.66.1792549588210;
        Tue, 20 Oct 2026 19:26:28 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c42b17sm13170296d6.40.2026.10.20.19.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:26:27 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v3 bpf-next 2/5] sched: use static_branch_likely()
 for the NUMA balancing tick check
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, 
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, 
 tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, bpf@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261019064157.29885-3-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-3-laoar.shao@gmail.com>
Date: Tue, 20 Oct 2026 22:26:09 -0400
Message-Id: <179254956989.1919196.954997201143423051.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 0F00A120006
X-Stat-Signature: 81gmq939yy6cytmtyames7qsw71tabxq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792549588-552668
X-HE-Meta: U2FsdGVkX19VJHa+PW3ObPb5VQf7PWEfDoSrkGfioHDkR/BJbQLRVLDjS2pQqqlRl4dNxr6UkRetBBP83EJXlmGnk9G/n4RG4/0ntMu93luKYf94w3Xtsxvd8UpJYiIhRnVLB+6wT8Hvw2DzTtAyjldcHCkXr2LQGpzk9jtoHAICqOrbw8hifazxT4w+l7ngokgvP09QCFVSkDOC+JWFjcPBDTVeW1/sTGDlYyAkymQKQ+xIlGR9WojeTACktO+Ra/xSx3ty6uQqzU7cW/RLPPOy7i+U3NeHPV2SAF+ppeJxnD0j+63SIhe0Ykrj1VTYeMimHsz7X+sZCb6g/99uX1e0h1ReRMZHG9EpEWNzfqlF+mUbIABCbI8Y61g4LkHpqdpaHE5dzF9JIOf1bSakYHG76qQXiTzZRDfWVmP3Q71jrzdVlQxF1yNhqpWWsNZg5q99SDIsmGLpg3Ht4fd+b8g1sZEb1j5yFCEziAe7ZmuczcbL4yIyARH/0VlffwxfSyvj7uKAOK18p7+BAvzCDvYl/Wd1pguYMYC6aem62C/Oi0mCKWrMcD3yI0ZjAwhUOA+hZIc93qPkHNfUba8p4MoMiFmQ0Bwv15p/3/XUMlPZUaRxYfy9HMjoiXeawqBFo4zqRLRaB+5Oo0fmZ1slg/FCiUrJ3IwLsGWpXrA6dvoEEGtvETGB+px2+HG1BFLWdRjhxjLo9su/nAK5Jc9m5k73RUeRTSIUek8TuWl1lKurAvod65nKY+JT4hrU2trbMfpVR/Aran3AX4We2eiCAOQFwJ6MAFDTMpm97OoAVijau19kzL5RJTaSub+suFuCZwM1UHRtJcgeoeM0gpoT3jyiQmVzS0CPZZmKqQZv12ePQOcQ9F/Y/+qG8uemyH4Tpli7maPe1DhuptCEJNuPOiEw8wpyqz2CfXhN+xPURsLsBvAfFbQMHIQNhOTx4ZzQ5VumbXQilYHXjP6NmZ/
 Gj14yqgh
 UgZ15cUJEKpvtcrN96iYLpkI6LiAI1lDQqxzFTTmK7EcOCL1svxh2v2F1rQRFJMXZe/5B1NXf2SRMlFOxzTk1VN2blAlj2QkCEGdS3qDmHKbNK3a8BfkJyKNME36woVBQhpy/wGsFkd1c6U8PCKR8SBAaZoCeOCv1IdGZwhOWl9OQHa26uMGXTZWmrKkf9ApaEHigGvW+K6KLiN0FvCsm05ZbgaypKgnuANwvJ4aCyGUH8lurFgldNKxlK90yrnhs/kvevADJrO3cJAMCZE0Ys5AZlUW7ph7pIJI0+f97fASsWYC0IpivZe9wF4m/SHalV1/4CfdHUcKQcB8bPd5DLsyaWe6mNnUtjbLriLEW7VeDi1QvOJjv3iDWNQTfM++IZGTWD0X2VPgLx/pAyiRjfuo92l1F1D1tXdev2VidnZc9jxosuqWoKLTC8+1YnQNez6SXN/mgED8zW70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-19 14:41 +0800, Yafang Shao wrote:
> task_tick_fair() checks sched_numa_balancing on every tick. The
> static_branch_unlikely() annotation reserves the nop for the disabled case,
> so the default configuration (NUMA_BALANCING_DEFAULT_ENABLED=y) pays a
> taken jump per tick. Flip the polarity to static_branch_likely() so that
> the fast path matches the default.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

same with this one, this is useful separate of your series, please
submit separately.

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

