Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5590D13C1B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4076B0088; Tue, 27 Jan 2026 04:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A636B0089; Tue, 27 Jan 2026 04:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063766B008A; Tue, 27 Jan 2026 04:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8F8A6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:38:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4701313C0AE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:47 +0000 (UTC)
X-FDA: 84377244294.11.60741CD
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 43BB340016
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b+wVxRiV;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769506725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7RNZvCglNdawEXsv8dR65PtThO1YYQ8625navj597w=;
	b=nsKMWGqIYB0vTIQDtWiWC5xc6l9fxkVLDJuOIgVw+Wfu3vas6lHNiKEo+uFlVRD1+Txdxv
	ZNNZr7KuGfK6qdMB1eFb/0CJVtCo8Pa9Q8XgxPuY7SjoLKI7WQfYdI3PnXPzT8C1y2rXer
	BgxDwq8zK1v5H7RI1NPr077BfLcjI1k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b+wVxRiV;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769506725; a=rsa-sha256;
	cv=none;
	b=Tf8vU341SCk0LE63Q9nZooq6ekJ33aHx6TwJ9tIhddzanPJrgDvKb0Gg2Ny53TmJTV4upF
	2kbqwqlNVri8gNcke3TQJU7PlRkeiCYkoPeOZhjPhW7C5uU6DI7p3EG6uUEC0hTCIoayyB
	I6CwngtJpyPgrtCnu9ERYf76pEu5EoQ=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4359228b7c6so3505015f8f.2
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769506724; x=1770111524; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P7RNZvCglNdawEXsv8dR65PtThO1YYQ8625navj597w=;
        b=b+wVxRiV7WiN7VIpR95jYFMaQP7dfWVgHrTfVXM8vWQwxkCs68WAiRMi8PyRszJMkn
         BH2/VDmZWTdqdu5kUtD0LjeAJ4QYhOou1vM3//I1E6w2Ku9WKlRFavDId7RtGOLk9/ja
         O+Onhm0EOyVpwSG+jT6SDP94DSmm3vmiJvPAvhe4ZBShnRmleeIF6GH+X9oe5Y9RaN8J
         ViTbHzOXFnX+5EZ25qYS9Yc1ejcpCP2A7OWzdqQuHwpQRWxh1iZMG2bZI8+bKl9O1oe/
         Nvm14dKOpBzKIpzz7/Vh2fgl/ULqO+E2NTXTarrYszPpwSxFvooD3CyCodpoX1f+W5Q0
         CVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769506724; x=1770111524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7RNZvCglNdawEXsv8dR65PtThO1YYQ8625navj597w=;
        b=w8D7+GEmq2dor2bP3VbJJWGKG5L5ctoXYxpN0dt29D1evLUtNjOgtZf8c43/HqlfU+
         qu4o7QC8d1csSdPb3vs3yFDob8tn5YR7iZypkLdeZv/JBN7IM0QNc24R1Ueo8xMT6z65
         24P+pxwsVM5hFlk4R/0GUkPkslRcf54/c++uSjl8GEL9Op0VIa7r4lGjI2RnM6EErsPy
         uQGnbhsM1ZV4wiCx2dOK5pgHR4Jc04ToPPSgWm+x2WENvHM9t7nmqBQexqWJTRGdoDlp
         L9qJm3lMQd3Uu8lz60D0Q/NuQwX26EZCbaOqcuOs8D90b401nDxRrc7jc4wdHQEkrCHa
         p/Jw==
X-Forwarded-Encrypted: i=1; AJvYcCUuYjXPHtTWp2HJTt7G9roAAYNeCKTlGE4Vmj7SOxC9oARNT5ItyixKUlHYedlx3Zato5beKrLdyw==@kvack.org
X-Gm-Message-State: AOJu0YwubhLSDV+sDfc52ip3HcTcvdhoeTFnp1C/La/9PJhNnlP0rW/N
	gWxa0CDV4cTj3zuU/PJM58hQBzh5N6NPzwMw056IbpeWc4KpdIe/Oa2e6IQvJnfoSy8=
X-Gm-Gg: AZuq6aIAy61OHF5Yb5wMjJyYU464fv2/wQomyx2j0bUZKWBWdCefs6ZxfngiOqgTK4a
	LNHSkD8yJX6XlVjDNgB10ggS7LROGzkXVeIHOaBbaPqRn+ubtbDitcZixQcEi8zhKH58pn60WYx
	Fi6J/sDwAZKpqVaAhlkG/Q3gZWVDylYyLvfCWzKDbU6V3qhzF+DrdWAJKWTjRMTsM3chruEwMF+
	eRoZSSeQ5LGfDFfjZsi/FZrKRQtx0GAzxBl/WT1Wl1TjrItdv2a8sCUWEQIMfZ67DqtfGtgREI0
	W4VzmfcVfLy7aI+vtg6A398MOk8Tn5GoL0ltfuVbl+vzbPBvTHikSNsmewrGI39zXAL/9kbIeLT
	ogj+iB9cATuujmoeeGe3jrPCLcBjzEbwSxdRHI+0m0NiR3s5dPSg4oHSTuUuXu/pSf8IxG3PavI
	/QvjrLKibSte7sE3O5Opt/PaQI
X-Received: by 2002:a05:6000:26c7:b0:435:a135:7772 with SMTP id ffacd0b85a97d-435dd029989mr1577820f8f.4.1769506723593;
        Tue, 27 Jan 2026 01:38:43 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c246ecsm37781344f8f.10.2026.01.27.01.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 01:38:43 -0800 (PST)
Date: Tue, 27 Jan 2026 10:38:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
Message-ID: <aXiHok-3SKqLncCf@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-8-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-8-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43BB340016
X-Stat-Signature: na5pbgo9cfnemioe1sbwuf3m1x1e9hse
X-Rspam-User: 
X-HE-Tag: 1769506725-121946
X-HE-Meta: U2FsdGVkX18EptLjQfWE51ZoluAfenmbS7hTfnZA9vshXKlpyhSEj1Na+IgfgTMw6jFRbcJYZtpxObvGOopmVIFJH5JGjeiT7qjiNW9T18eYda1tvmZcI3IG6VZMY6fIH9FgHcUTjwj88BSfHLO97lspwE7bvmoMc7yvoFXCNW3GTCHXpIptEMSe2x8haaeUtgiEpDW9+QitE7b3EVld0W5LkwSEQ/4P+LJbb3Svhf8EmYhWE4CG0tYtgMY/tW1r0aspQTeG8L8yPzWP8/T+x1ZzpfI7/waUpJAFC1BYdCFxIX/VtRbwnqiAJB6ayebd0MpM1791hTm1yVaMYOxM6bFkdD2snrseTaRX8p8LMtrXCPk27Y7O3BNRaGyIuRluALrgXTUzWnHHqa9GrDtHRkpEPXf1KVs2OILeR+J30DqGLZtrobFHmCkIDTpvYlhK+RwC6RFP//u52PGBc375WUx65/U1WmtnzU1+HIQMvgbuujfM2UBQwuVlF33En8+vsadI7QrxLx2avbHiRhyUYgCtXrg5zD0WhMn8cz/OBcLlneCFvFofSYNwHKECHK6tLXoRC9GjNXEgCoQUBI+//JvKnZbZuE2mzR2mzvi9Mtp5EIg2xfm3gKjMXULtbrAGFmNkrh0aiBQa0VHnwU8Sk8FIhWOQ4hK7sw7Md0peSkfJjVAi011d1W1oOBSywQBdc0M5hBh2X2V51Tvd2ppzbgyeP9j2xdYTWYRGlrxi0jLD2FlDr4ZsEg80yiMkXBZez+xm5ccm83Vwv8UgGMMBjSqWZIDgMIhjUqH5dlzp0D9VBzFdgN0WH0onUkT80iLwHMSr2b//bAt4A5RDJbi6V+w2FIL4UgJPmsaxd+FE+Y84RprKvRHVbpRpXojiq1DkGjIO3ZR9GH6fuaKqC1wRosYeuskzd4Un3ULEHrpN9nVPtmYELmag6QpSbp2wMUAH3rUfOLacUSnljSWV4rn
 UuAByTvr
 KrJJ/VO0A+kUDn00U455JFVF5MrmAOEDWSWn3prb08yzJen5PH+DiNUPh2oBMdxNq5QQ41T3yZY+s+mY6N+skEItMvAjNj20zrIIWS09bn69s8QJ3MAqDucjn0/7FTGvE9QgrKxKsz551NKjRg5CB8S755bljvWC/F/uptIlu3ADYoxOTaGfrpqj2bP9ro3VYLYy3hlnXNQpLn7D9mNyjm7Y9oMoUqv9vS2ZJ5Oex3Mr69lRddVWq++p9OWxiDBn+EeIlf7l9hFdDfbhCzb3jCXvsMEBxL1sEr34ViniYLvFU6R4ZhjB0o6W9NfeUh4Uwf4ycj3Bz8q25zzT+l8lCb6siiel4giw8WEeAlGU8WavdJlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
> Introduce a bpf struct ops for implementing custom OOM handling
> policies.
> 
> It's possible to load one bpf_oom_ops for the system and one
> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
> cgroup tree is traversed from the OOM'ing memcg up to the root and
> corresponding BPF OOM handlers are executed until some memory is
> freed. If no memory is freed, the kernel OOM killer is invoked.
> 
> The struct ops provides the bpf_handle_out_of_memory() callback,
> which expected to return 1 if it was able to free some memory and 0
> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
> field of the oom_control structure, which is expected to be set by
> kfuncs suitable for releasing memory (which will be introduced later
> in the patch series). If both are set, OOM is considered handled,
> otherwise the next OOM handler in the chain is executed: e.g. BPF OOM
> attached to the parent cgroup or the kernel OOM killer.

I still find this dual reporting a bit confusing. I can see your
intention in having a pre-defined "releasers" of the memory to trust BPF
handlers more but they do have access to oc->bpf_memory_freed so they
can manipulate it. Therefore an additional level of protection is rather
weak. 

It is also not really clear to me how this works while there is OOM
victim on the way out. (i.e. tsk_is_oom_victim() -> abort case). This
will result in no killing therefore no bpf_memory_freed, right? Handler
itself should consider its work done. How exactly is this handled.

Also is there any way to handle the oom by increasing the memcg limit?
I do not see a callback for that.
-- 
Michal Hocko
SUSE Labs

