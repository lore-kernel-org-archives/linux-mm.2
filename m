Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74354606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=jHVPKcEh
Received: by kanga.kvack.org (Postfix)
	id 8C0156B05B3; Mon,  2 Nov 2026 03:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897F76B05B6; Mon,  2 Nov 2026 03:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7868A6B05B7; Mon,  2 Nov 2026 03:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 517096B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C27631C400E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:26:32 +0000 (UTC)
X-FDA: 85389497424.27.587662A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C12F140004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:26:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=jHVPKcEh;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793607990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcE/5rnGxKA55YKLDJm0k2JZRyvDK8vL0G/XzycxiFE=;
	b=e54rUzamGWrl3bEPsvkXx8OPR3NiyqLGq3kR7sMQWqRtoFFy9VbMwW27rNi97rC8Jz/Zwp
	Sk9K5SKRhwh2lQttBujPs3U9blVI4hOI32eAff7gjQEi0MkTKI8dwDc2+OfyWg5s7NCMW3
	NWSn0/CKByZwxctkcbvjTZNyuF6IqSs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=jHVPKcEh;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793607990;
	b=SvlIx2pr3qMXAdnNQ0lUfvnvxwqkGjWNhGHkAzk5GKt35NXXvEKv9oVCA98F4wt2qN5UEU
	WGRfm9P/gcK2L5yWKe/OdrfKhX1cSOD308zofrihCMzaUd6CEwFAzHqmECJnGVf/ART0vY
	FmnAeCS8YPZRGrTR8aNebyYhg01uLXU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso443064166b.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:26:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793607989; cv=none;
        d=google.com; s=arc-20260327;
        b=r71QKQKui5DtNimkgwYCA0Cs8GfrDn4ujcARnXFlYW6zzSLvn4g3MzpDSHxr3IKwb+
         A20qExOkwdtvizJkLX8XHCjW7QUKiWZxzTQOUVa5niOAALHCmBzL+rAW40i3prVezpnH
         wK6Ift8Btt4rL6XXsJ6KLpiCFdVpY6g5w+tVAxJ77djgKthRIsnl45bw6Fqqdzhkxe1Y
         cy2/2YqH1BBJeDnnvyiQVmZNkfpGDcZYzopjjfhtpmeA61of9dcUDqdTiSgv+BpxgAqV
         OHpVWCODWTx8xtuhQIQaa7jO/+GNxirbeCghPsEBxxcbyWkTMg09H/Tl80QmbFAFLmZJ
         AJww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dcE/5rnGxKA55YKLDJm0k2JZRyvDK8vL0G/XzycxiFE=;
        fh=xhMvn0QKa7w9yWCrbGMtFlwwDa/8XH+J4L9/4xKyRAY=;
        b=m8qZcJTwupG03q9eeFSaQ0g4/o9bh2vbiFf2bteLMe0dZ9NS0tQ6E6jH/86hkjRIBE
         fjOlOZx9BAy4h7Gsq+FnGFlGptgz8vy/EGhxS4k1GPcGxJc2XkZfTSb3bt/QcHPwTNzk
         zO6kWrUQZ35PYsbsnxDpkFp5cTRLL7NWMX+sy4b6XekkB2UpEZ8C+rLENvR3c9x+t/zM
         yrjVgyrdwMG/+/W5mLTmHmuWLUthQ+6x6BaeXDX2uItLBCq4nMmEB+dzdk5qnlRurfaU
         SLz79m/D6DglsEDXie417bDzVcGdmi3Pi4y+VsuMg+QMM7Hu4xH47lO/X/QGhMD5d/+l
         AQKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793607989; x=1794212789; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dcE/5rnGxKA55YKLDJm0k2JZRyvDK8vL0G/XzycxiFE=;
        b=jHVPKcEhnVEjXkkMENGUaSRyZgdZomGMnCcRmtL3osCliWh6SaNvlhhW2J5EsAONSA
         uqSfFB/pp1fzdRYdylEOGe3EQFHMQsQRpxY6zdxa2rKPn1p+RCyTjlOA6Q9XmHdJG+Wv
         nSKghBL0l4QKP6botLK4WW9L8MjNwcHA2vzZ6LjfoAYen8KIRoLg+7X6Xg4gL1ZbtUiy
         HTn5LpsLg5ZuUlThFc9nj3A+hfr6+avKC2bG9USkV1ABCLQnFbwfbMexccYEppDe5zre
         uhIpZDY287fD/7b5aCctU1Cmr5E97TFQNZf3TeH643deqfxaZgMk8fLO666suO6QdbvH
         u/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793607989; x=1794212789;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dcE/5rnGxKA55YKLDJm0k2JZRyvDK8vL0G/XzycxiFE=;
        b=Zo6slHCR3CQ01OhfMIcaNpkQ4SuHtVTuydIAUkWWWPcEY2gUyCq/wwfo877x1MglNM
         r/JAwldvj9EaNOCunz4DDh/QxZAVS/i9y2hRJTe4ZazVtispJNZOJ6Wn4AWPblPqVuHN
         PhQ/Bm+g48YsnnJ9XGi/KmEgFM/J/Yn97BZkzVPUn3+CbWBtCLF3ZhiCA1sM+QuenzZp
         mdx8xA8l9PSh/5eYhvmks1RyMObk1kictaMnkcwwdaKDlNtoGKtVIxFMxTSL5x5YJVA9
         f9a3J77ydPLxci/AqGZi1rBgB+g04wCwuJ46E3ay0Q9CyeTCAFTXNxTtoMe1NPG6Rt46
         ebpw==
X-Forwarded-Encrypted: i=1; AKwUvBz2ntDz+9A9QVmMYlIpx+WGBBObQ/86kgTz3ioBO2y7UU50NqaRVVwxnpJTx+1Z6awin+cdTMNmxA==@kvack.org
X-Gm-Message-State: APuU4Z926SMJ0sgxkLS+8Ve3fj57gUNZf1dxM4Vhw6hXY57ylp5lszVq
	Za8uuX/2RHZZ4TnZu/yUEwqlQWa2wVHlxAYzWQZ6eaxd+GLvvgaLzC/o7PAVOjt9EGzVji/REn5
	5jl/J3uHksnTa6ZcgGlm8nlVA3t3phaabgkpa7aYRRg==
X-Gm-Gg: AYBFou1zQdOCVvY4H9cY56W9j+1181jZwG0pLzXlA+WXo2LwzmLTyHnatTEY92l/r8x
	pmjPDKig7hJ67DOQlqKBQhW8g4vWDZpi+oEE5DGCD2Aqd9lr71BPSNcgmWah4HXXCi8sRziZG3B
	QewXGximGDw3zWrv4/Dw6h5hbPwTI3Jkbr1emDgyX3AzGBRAJPKNp3AgLBnpWYRBk998cgW7C1O
	mikYP3oi9DUdHiI5rXU/h7KGSbO+nL8LX3AB59rpEWNsMCn5lIFEOA/z0itwAVdWmCfVKBoT4S4
	SmhuNi87+bcrQ1i3WHOvnABVf3FCzNTN05Ru8Ddd3GAd9ifCR0bFnnUTyH5NIeocuS1NFQvrTpK
	M9wuBpMNILLDYYyG1VTTYZ1pBL3/G5splVhaAq0THPO3+6Nvc39LV89oPalf7yUVrzlpMjivgBc
	IZMhzfULjGPLXo
X-Received: by 2002:a17:906:ef0b:b0:c33:923b:ad66 with SMTP id
 a640c23a62f3a-c4ca7acfb4cmr790165266b.43.1793607988903; Mon, 02 Nov 2026
 00:26:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-4-max.kellermann@ionos.com> <a64f6a98-de70-4004-aac0-312cb05aaf92@linux.dev>
 <CAKPOu+83bH2CRtiAio+1VTTQrYFF9th5XfG5wL45ujEavPS3Dg@mail.gmail.com> <20261101135047.61fc3f209b3235ed6fc96183@linux-foundation.org>
In-Reply-To: <20261101135047.61fc3f209b3235ed6fc96183@linux-foundation.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 2 Nov 2026 09:26:17 +0100
X-Gm-Features: AclHuK--3PTuMj8RZeBQA28BApSOQ09xugBp4TxqQtGO5WmzRMN0zBosAEwqtzc
Message-ID: <CAKPOu+-e4uPhjSj2KxWojDKJ6GsK51HrWMOwN9-SAnqi2gMW_Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C12F140004
X-Stat-Signature: 1amu5nehpyancjwyehx1qh7jriezh8ct
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793607990-390989
X-HE-Meta: U2FsdGVkX19MIcQSj7DzR2Q5rsBZ4V+xTDGjO+f9/Vxcn5rt6meArKJEIEGPflh+aVIiqh28F/9EqHUy2YwJX9L4eSZxPCdgxcYxehM9DeORdYhRLHSSCZgSEV2O7JTSSW1Vx7G4vSpUzSvhBoT3OxyaM+ZfM1s/STGvcbszleRrpmPi17XCyrn46t7ddimIrG4o+Lv2Pq5CEElDng8WfRIsrIkJ1wQDoh9lNpr7av6XRuacCUDVA8qxZ5yzo2kK+6OxP1Nl9nUeG3TcfberesZlXiAcV812j3WXWv1WF+bxw0aQoGgWQxMozkVq2m2oy4aKGkGBG3GR811M8IxTch+E5i4/3FSnwjku9tkplPYbwQLM1301xR/iG5aFpf7sHgRvkrW5Mzp3B3zQl6rLrxfzrYn6kCMzEoXnq42uNQ9ZnV08zx7I7pbycrbCvwxNCVN1WEEyaYMG4Z2JLJFptG5wHMTvh9GtRTJsSKRqOIGzXx1t53Kis87S4rZbdegXIXaEPTUOcqZoZplO9lRQEMPSI2jc2RIrzVPYVI5N3Tcs0wmO6oWjaA7tG3zNwYwKsLXH1sMF4qvEEgdymJiaqg+DEk6Z+6UE8aL3PufZR2GSMYQuHaOYNhFn0augsWI6YQBytHCOfzyD8zyH0tsk4Vz7iUasi65TbnNn1lOmwYgP0L7nZqlb8m6NSq87rCxsXB2SUivRnKNq4EYjREj6JH9rn745uTUKdTw3kT7DlYHImZ4DDQyKCg6pB754lwCZUVHWDUm3Ac9P0lcD46+sWJURcxbhljzaQabTvhblH47t+/JPMSZuEY6EVBTPFqFFxRnJRjmRH20aPOhzz7ZZIFpkqVWgXH8csQueuNWIaPgqL8iSFqt3S9b6EHwZO7wqEHgrJmDo2ylA4W7SNU/pBG02XzVRLwEDCJiOL1BUNrXbqSEYdl3M986tVqZQGKoAyffWO7SN8+pXkiEtQ9b
 BjwPSug2
 omfoO6ZL1YPMRqW8PtrlUBeXqkvE+z0rhoex1junTIghOvPU3zlbMNVMoyI29QYaEENtJyAtawdooUSLu129DU9GzxstKfJt90DevAvuqjdLWKVKEYvoMMh9heOZk8plYBbyOA2WFQRZSIfxstGiuGAyYWxHgRCvk8Y9gnsswVWEtS70no7X2/SrZBaHnKrj8is6Zh5GoAP4EW59E8xunbSSflkzxC1eYegvoW8K1cBHpqcTi6nyhGGNOB6xbX2WfrwVja5mZdAty6+tZYwdlPLdV5gQT710ssY8e9RGAg+iRj00a+T5Mst/ZMfjU4AtoPd3bz4Rjce2I9j5iHtibFd1LpiJ3iLKGcgRQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 1, 2026 at 10:50=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> So.  Can someone please propose a nice simple quick-fix which we can
> backport into the -stable stream while we work on the larger
> rearchitecting projects?
>
> I think that might be Max's [5/5]?  Max, do you know whether that patch
> alone will fix up 6.18.x, or do we also need to addressed that lengthy
> spinlocked tail insertion?
>
> If you think [5/5] is sufficient for -stable then please propose that as
> a standalone cc:stable thing then we can look at the broader changes on
> top.

Depends on your definition of "sufficient". I guess [5/5] will make
the symptom go away (the stalls), which is a good thing, but I see
this as a minor incremental improvement that doesn't solve any real
problem.

The real problem is the degenerate performance due to a silly linked
list insertion algorithm (traversing the whole list each time). So
with just [5/5], you'd still have hanging processes and abysmal
performance, no progress anywhere, but nothing would be logged. On the
positive side, not stalling RCU would at least not pull the rest of
the kernel down with it...

I repeated my benchmark, this time with Linux 6.18.60 and an isolated
run with just [5/5]:

                       No patches    Only 5/5    All patches
  Requests/s                 5.28        3.20          50.91
  Mean latency (ms)          1494        2463            154
  Max latency (ms)           3932       10467           1685
  CPU time/request (ms)      1494        2452            153

Patch [5/5] does not improve the underlying performance problem,
there's even a regression in this run which might be noise.
(My micro-benchmark does not reproduce RCU stalls and thus does not
prove the RCU stalls are gone.)

If you believe [5/5] should alone should be a stable bugfix, I'll
resubmit it to stable@.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

