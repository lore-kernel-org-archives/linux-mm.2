Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E5FF532C4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 06:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D96C6B0005; Tue, 24 Mar 2026 02:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289AA6B008A; Tue, 24 Mar 2026 02:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5266B0092; Tue, 24 Mar 2026 02:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7146B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:46:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 875D71A1630
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:46:10 +0000 (UTC)
X-FDA: 84580022100.18.D1BC099
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5204440007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:46:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W9vL/smi";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774334768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZ8xVYWaHSz/DiDizdbC8TysAumrqF9ybkeOEPMtddU=;
	b=C5xj5uL6O1IcdYcNILm7Gi+mXwtqlOODjqsIKmo+X/tsDcGJVXtQWsatj0I08FxzGB7s+a
	pCfwp0hiiBrzTS4WCyEdFp6RTyVCtVmahZ0Euw/cDAl3FLtf+QtxWFq3q9CvNI7MmssD+Z
	zAvO9poW42pWr4qK99D0fylXukB23zY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774334768; a=rsa-sha256;
	cv=none;
	b=1a8mdQz7+u5jYd7biBaFoY7KvQ2sYKNcgwyenPpyVZgPQUlqHt/Tz8eM5akmkLD8FjQP+B
	V9CnlVG0YQqZws/MoLbdjaAmSnfgawH3BbB8hUMDvLmCU0kHjjTrGSAIk6qZwdzkf7b0nm
	w8YNvm+OIvGfSqeUN47VAB87N9wwi0g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W9vL/smi";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774334767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HZ8xVYWaHSz/DiDizdbC8TysAumrqF9ybkeOEPMtddU=;
	b=W9vL/smiW1DEuidzO5GN94T0nLM/TiQvtF5vNu00wKFbECJ3eD+CaXXBpmuscrOcN1k9gQ
	hRJHMnFn99k5qStheGdjiQql0/1DIWhdqBZghBZUA4la6oWy9h0HTHNKXswLdZKkYX2xUa
	mod5pSptagfT4/p3cUbTPra/QV3CLZs=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-cp5Ti4ydMOW_9wEa8lYJWQ-1; Tue, 24 Mar 2026 02:46:06 -0400
X-MC-Unique: cp5Ti4ydMOW_9wEa8lYJWQ-1
X-Mimecast-MFC-AGG-ID: cp5Ti4ydMOW_9wEa8lYJWQ_1774334765
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8230d6d54a5so5228600b3a.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774334765; x=1774939565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZ8xVYWaHSz/DiDizdbC8TysAumrqF9ybkeOEPMtddU=;
        b=FJGIjpzEct19a5Gv5UsYhaZe87dnN+9p0IScGp5hUgrQPo8Rn1uz+pCy/cZ1KRYaeJ
         cL7NCpOXJAkop1YpH09ZAiwOwLrRhOHc4f5AoY28MHfcq4whyhjpQCM96pq86xvbQmXr
         +opLjtz34kIzig18sfBapHU3xpkhixO9edBJtRPxtVdQAgZQshh9zdJ05JaUf9636yPq
         6Muxe2LhC0jQAm50sRZKOdIuCM6CmcJ6qnWxmHgaSkO19pVducKwZ4uzlOUmJe3smXE2
         77v/SWgCFlV+fn/OmHmuY4b1b1sLChGWHVurstv+oBA0olfwNEOxq0BCUwUUbsbP36ug
         aHAg==
X-Forwarded-Encrypted: i=1; AJvYcCX/EXfLEmxUOECpL0NhtLZ9p6mlRZni19u0ASLd5kS65Sg4J7IVoZC09Exng8FK4qbsCqChniRYNw==@kvack.org
X-Gm-Message-State: AOJu0YyRTuGjAg2sOetmopjZN2YnLP0SGx2aG1M/HGKCD7N9JBZEt403
	gthUq1sGLk7aREdyc1rE0vpvXn/OKE5RpvQLeZDHpy3dDbkiY7pCCdozGDsgT2aBATNspRIQ5Kp
	9KP+U5n+NowtucKq/QvKDtoNTIF/aR8YI4qfB3JKb6JrtVmyrS2q6
X-Gm-Gg: ATEYQzwOl9oZGERVMAWMmWYBd4s5/nWMsHkMV23ryPxVeAXYrMpc52vcpqVbkC+GfR/
	y9BqCI43W0AXWY8Ng4E/6FJ5j9bk8Dg+2ukiifw0wPUtiGjVXLFTiNcIFxNFQye6n9ReYZbGw1R
	En1kxg56/ociee9CMarXLmepcTqrZGZPgJlGgRZCQhRqVXp/91Xb/3TKyknDW1DL9JDOjYqfPSm
	9XfQSgf/jZZsy47nE1fxdgkTSyh5edwuAKvtgLq1/dG+TbmAlqXWWmFv6ZLcf0zBISOHodTiCNS
	ftnIKiaHj1L2phM/VbWPuVW270n0qjievP2bOKXio9C9cfwZM5TRrLluemdtc1FD0ZDG+FaTXaZ
	sTmnAGrE9NebiEIIQAA==
X-Received: by 2002:a05:6a00:94dc:b0:82c:20c2:81d4 with SMTP id d2e1a72fcca58-82c5bf386bcmr1893823b3a.30.1774334764948;
        Mon, 23 Mar 2026 23:46:04 -0700 (PDT)
X-Received: by 2002:a05:6a00:94dc:b0:82c:20c2:81d4 with SMTP id d2e1a72fcca58-82c5bf386bcmr1893812b3a.30.1774334764600;
        Mon, 23 Mar 2026 23:46:04 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bc1e59sm11954332b3a.13.2026.03.23.23.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 23:46:03 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:46:01 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, yosryahmed@google.com, nphamcs@gmail.com,
	hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, longman@redhat.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <acIzKTax5hpvQUkT@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322061038.156146-2-liwang@redhat.com>
 <CAO9r8zOwPnP9_AMX7Z_w4jLMYP=Ujs3BxNLWVXHOEAKVGFGfmQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zOwPnP9_AMX7Z_w4jLMYP=Ujs3BxNLWVXHOEAKVGFGfmQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LaQKu8O7-FSPY-skylIB8dCO0O0xQAeROecJiZs4wC0_1774334765
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 5204440007
X-Stat-Signature: 3kgtdoxjdaht6ims1edut1w5ba9nnqy4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774334768-937189
X-HE-Meta: U2FsdGVkX19mHxWHGiRsc09yE7u4kJKYLI34GsbiTxgSfF/XRBSByYyftmu5pCfAr/h7m49iLPQXDuWQBS3GY5Hjb+KZmcx8WQAwfurKFlAYMIoZ4u4nPwvskYvtiJ0RFj7YI6LTFMh8mbSK0aiwmANPtTfaMaAeQRfUwVicTgyCeFb84GxJAKDNkuSKrH722sJL45g06gJZ4TF1SVC8vygmddSXNa6zM/kNZ71byrzvNM5xG87yADEN5vB/ik538df4AwO/CQycmFPgf2SiuzqfEkv0p94igUUMiNJA1mHH2ZvTUNJAdbGdQIHkccQjWnOMIDlQQ6AnlA5cn11CB/yH3EOfgrfZk4zvgrGK8ENFf+zVzwNwbXxYYroVg40HewbMKJOc1iPMdNjO8b1GV0DiMaEHDG8lLW2WNjxOBIBLUAaDkJvIh4TRevU/Oq8ERAaVrP2ALVpfceaLmMlKwmHtxupIDaw66/g2aw2Td0zjeCEwMWz7cbCI4Vu/7hP9qUvGzA+26rXPO/8f1lzviEWQx1KmNSl5T4FC4Jcclo5NGQXP/fwhMfmsgtgton60QpuR7ty8ijrz9A5Hws8AS9jAxtOOmxP1RpiSTtLdWJ6uAuTlICaWY4dPIueLkgrVOCxR4kz2L6BmZ20e1uaD7Ky3dVY3nK51d2SUNXj3/HQSz88S+sgO4ecxCy7UaGrmxwNTnfprLCkP2G6JJbpaptxkIjqSa9d/WHaFcxeDJ/GZycNxCAf1YipbDESyDNJZQbB3FJ0yJLgdKuxG+4BrlfirdtpMAqZ/TqwSqttgwXRmkdKCcanlhAj7ipg8e4GLP+VuuSsr01xar3V7Zp1zrmaHsKiPRkRLnSmnbh/R1h5VxclDgJ/JJ9aiH1l2rZwoHjThyO9pt46D/lBN3zqbXKXY2riVGWbA4YXA4lmuERz6yjzjtARM5I0as+sfBCS3YlH5iqOR3CgBtnb7wgr
 gUw3jMkN
 wbZK5/RcVTL9YKWEygX1Pil7GBFTPkANP5vsnwlsqDg8i61SlsfRl9lcLI4gzRFeZRrvL0oMbiJpAmkPN0H+ebCjLSIi7T8e4j95E1CELGDkUYbMtEyGeeYZDzCOfNBN/oi6va13b5hPwXvouwHSF/d2lRIOQ2j3x1ZMpVFPx4TrI3ArpkyZ8AmkPbkU8TKfbZcroA+kSlteCsMlosaJ4j1cR9yjQoa3yRFxvQst3bygn9uLOZ7jsHzRrY5YFLpiMD5H3qV/Zk1GH+b2Sj0XWwyAWELBYwvx/wM4RG4WaeI1yCGFEdBmgckNnGY+BzJwejQnCVkM2b7OFC07W4OBjN4s2QCJVulObGG8/nVuMaY4oyuyBXU8qTI0JX1p3h9a7/EMiH9Yk8xMghts63p+Pn4aHkdXy8A9GDbsIVyTqcRZGbPaio/nDKu+wFyTYZ4perZHQof+9/mNYCX4eQypstcENavsSg6HP7H0Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 05:13:14PM -0700, Yosry Ahmed wrote:
> > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> > index 64ebc3f3f203..e69d845d3592 100644
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -589,9 +589,21 @@ struct zswap_test {
> >  };
> >  #undef T
> >
> > -static bool zswap_configured(void)
> > +static void check_zswap_enabled(void)
> >  {
> > -       return access("/sys/module/zswap", F_OK) == 0;
> > +       char value[2];
> > +
> > +       if (access("/sys/module/zswap", F_OK))
> > +               ksft_exit_skip("zswap isn't configured\n");
> > +
> > +       if (read_text("/sys/module/zswap/parameters/enabled", value,
> > +                                               sizeof(value)) <= 0)
> > +               ksft_exit_fail_msg("Failed to read "
> > +                               "/sys/module/zswap/parameters/enabled\n");
> > +
> > +       if (value[0] == 'N')
> > +               ksft_exit_skip("zswap is disabled (hint: echo 1 > "
> > +                               "/sys/module/zswap/parameters/enabled)\n");
> >  }
> 
> In the next version please put "/sys/module/zswap" and
> "/sys/module/zswap/parameters/enabled" in macros to avoid all the line
> breaks here.

Sure, I will. Thanks!


-- 
Regards,
Li Wang


