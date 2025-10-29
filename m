Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC741CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264EC8E0072; Wed, 29 Oct 2025 10:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D418E0045; Wed, 29 Oct 2025 10:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BB58E0072; Wed, 29 Oct 2025 10:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2FBE8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:24:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A622D13BA17
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:24:31 +0000 (UTC)
X-FDA: 84051372342.24.8D4B573
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93FF51C0011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:24:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WSzz91sH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of smostafa@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761747869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYw1yzHZtok63cidNSQI3kNDGCJ3YniZmqixcpLm82c=;
	b=rUBokbmWIkqhn3py2fJD+I5bmYv7XTMBwtsXm0ha/wp2SghY77Le4/OG1ebr8NFpLjWuOv
	q7JIssSQ2D0V4GpN9KqSPxhI9Kqt8shTHhHZeiUA8yHLQuaSztnfBqeYTHpHQb8uX06QIH
	Xh5z3X47knnzMnPFOwo28Wk7O9jgxSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761747869; a=rsa-sha256;
	cv=none;
	b=arkPRMLWUv2Afd/tE8e32vdyEvzpCeerZPbUfIU8yatQAUxtmCwC9ymAja/dJMsb6NFOAU
	cc1KAfH+iKAmXvntWnuESSj9SHAtrr1uT++LNHnA1xLAXeVG2DRZGG05d8SUqQSuHoSchQ
	VLPGsJfUJA5dywobxPfyOx1Jj1ma8bY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WSzz91sH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of smostafa@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=smostafa@google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-470ff2f6e56so69755e9.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761747868; x=1762352668; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lYw1yzHZtok63cidNSQI3kNDGCJ3YniZmqixcpLm82c=;
        b=WSzz91sHR/AWEK/rhlqa8a1QMe8upgynX8cmV64QCTYZJt+VBNXZIPnxUEZSVy2mjX
         2JCtp3M5l5E9RjVSpPoFH4oPlj55rWFyytwBrCUe0qpIvJLUqkcs0/ohKvFLTGLvrX1U
         5nBB86sD8Amwoc88+Wz8ehaFCrt7befP5Com71SM0SbqDgx86FX24NaxiV921W80XQtg
         OzCFdJtSyIO899S2FuxpncTuMyVl4vdkUE3QPBqK4StwYB2i/iTqhLcGSuxIjlO4HkiM
         48YP4qKqPPLd5Wx9lrGJwDYZJVbjBaBfXR6kb3Gs2XEFLZWWBB3UqsuVOLI9r1zxbDcy
         RepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747868; x=1762352668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYw1yzHZtok63cidNSQI3kNDGCJ3YniZmqixcpLm82c=;
        b=hFk6m4CiOs87kFJvu5ihIZSXD21mrINzwXHM5u8pXaGGBB77QUAy/Q+MfvDM1Vg/KS
         DL6ZLmUFHScM1Xh8FvgP0ZrueKfYllF5WAkwTVce1EhueJENULZY0UbX5Yj1mwz3EI8q
         7a8LeMt3lqz5NcQyFQPlm7JcWdZ6Cgodn5telWFC/6RLqSpUTLi6+NLEsvDIWZB/s8vQ
         7JYp0YZV/X7sPlWGyZkEu8aaJiiK4PWkKNbsLDnU/HxOMs9jjCZHACREoJ4rU1ZbebKi
         dglHx+hwNjvRxY4U8U5lZyveU5NBkT0J3FPY6a80nPJXX8uhkurIOhJ+gicCp8YVRKxT
         1w8g==
X-Gm-Message-State: AOJu0Yyir1JaamkGyg3D4y+pgVGLPwm/FRJMNSsnRytlOZIFivg5HDA9
	sntgEpchRlnFFA6P9EkXDA6dpspfgOtv/XEURLUZzWsXZdtyoVZLjF6ggZvNXE8qeQ==
X-Gm-Gg: ASbGncvZU1irN8o2VZLdcd1wW8CvNhyvQj/RKCpGy3zjd34XKTDLvRaA9leVMtoRTVK
	ry6gDgfXZhA1NP5iTmM+9VVLldjHEv9x4wbUVoawAiQ0lk3cU1rKnHx/HIFLhAT22e1zpPDlV4V
	LZ9oBBiEesP8fcDyY5w0X//t89tZW0ixpNY4MyZw0jb0S+6rtvcQR3aDWiJ08KWczDCSI40fcFu
	JSW/lTrJE0iYChSFnemNBUy/WJo9NmdCtNDxFAJoAMfWUTANAjqjKlRadPjUgPZDr0YvtjwYVEV
	AZrjM7dXRL8m187arHrncNVP3F/CG2AqndYvSWOA26hLozvuuTy6CZHxvoSzngabpbDzIyWzBUZ
	qKmQFBSdfT98ezXAjZhzIwLD5Gj9v7AJtqFK/c1tiEm4mR4zK5UEx6FkTm92BKAqfnGZD79tY7F
	CVaE0l6Rb5rXzFX/7t1Oo4nGgErBXyUs80Hcyt2VI6u9gQ/xOazQ==
X-Google-Smtp-Source: AGHT+IF2w8kCzWJz2ny6yJjbrSOF+2z2doPlN+BMk2LktbvxhoCGI/5la8r3PEhEpY5MyiFPBKRJew==
X-Received: by 2002:a7b:c054:0:b0:45b:74f7:9d30 with SMTP id 5b1f17b1804b1-4771f2ee429mr1618205e9.1.1761747868039;
        Wed, 29 Oct 2025 07:24:28 -0700 (PDT)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d514asm26815984f8f.23.2025.10.29.07.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:24:27 -0700 (PDT)
Date: Wed, 29 Oct 2025 14:24:24 +0000
From: Mostafa Saleh <smostafa@google.com>
To: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org
Subject: Re: [RFC PATCH 3/4] drivers/iommu-debug: Track IOMMU pages
Message-ID: <aQIjmKSH8r8U7uMa@google.com>
References: <20251003173229.1533640-1-smostafa@google.com>
 <20251003173229.1533640-4-smostafa@google.com>
 <3ajy2xcjo3t6xdrbeo5xinlwtxzujvx4plzk3vqj3za7ren2rv@wdmwpjlaq6ql>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ajy2xcjo3t6xdrbeo5xinlwtxzujvx4plzk3vqj3za7ren2rv@wdmwpjlaq6ql>
X-Rspamd-Server: rspam01
X-Stat-Signature: 16sbmncxncf91zjfx47ypqy8cqamokjp
X-Rspam-User: 
X-Rspamd-Queue-Id: 93FF51C0011
X-HE-Tag: 1761747869-537221
X-HE-Meta: U2FsdGVkX1+3cl0qDqRoxj0/u4/JJUwblo2hvXGyd5p4p+jbNiCbQRycJm8OBjGFmldlJ0VI/hHFZ+950zy41dKLB+w3eBgAX6xneH+XUCk6+TumHand9UrQsmB8uvAl2eASBoP7lThxq61nij454petxjY+1SbgcgAfGo8LWO7JRx1YPdaXikhvdyYNwEgWO8ITgn2nxlcjYGna9Z6rTKZ3DVzlgrP/IE6hpvopQ1ZLPytRM8p4f4LaU5rAxmNjsbcQDcshw3YKfY8m+PatI2hE7DFbewiEtd7kDGg9CYdVrotfNUZhb4FZc07VcCLzlaIuS+aNcTLveyCMOoT4HsFQuOjfMRngx7+TwHrTDc2Q3omI5owMctzk4jAnTEeBsGMdUK6ZimqcibjvL58JU0iIiW9xSOUSuRFzb9EUW+7VK6VOa8+7nynWE+vIqi2qf0e67ENZFzv+Tpu3R+eZVT8LxUgH4x1ALvdLKcrY/wZTnNDme5NWLS6lXnA/wwgDur9RjecEHJFcPB4Jec5lJPoP0s/HzcECuFZP9vKVifiSqcc6/tEmriEQaJOYNdfbyyv3gAYTYaeimGGKSha/u0kFsiE2ZIDWL24xTNHYInA91WPQ69fdDn3kpsInGQQ+kZ+nnYgi12n7jTcFwy8WV3xz2oBc9Iw1YlrgKTGctKY+ZyKnZDvc03CmgnWaxpv4zvrgjX+KtYYVGJvQ58lbhqpBvUKcVnmmh0nCEG/2BM4LtxRx8n7VPr79ZSJEvUnC1HrZ2XOdwNPuXpKlAdL/daFVtQDvUeuaWA+TAy0ckUknsssDmro3qLMBU1kk3oOr6URTBmzHWX7qgMzVRdQ8SKKK4HlEn8510QEMj32ncm17QqYHvVNAFpD9FvtNc76n/IK/4Za6Q+PKJBTaAE6qG8eFMy8XJK9pFIr32P97VwzEMCHNKQQiyOU3ZE60/qlzAMWeZdrol8xu0cdjSR5
 ayyTlK2H
 ebdm0YV66Dw4Q+A8uUMPnK0p+6zUIoBOijGEZguGSPOiJXx5IOFqq5jUCO/eucdHHkiZA9/DlndKPs8EOly+AtvozElR0+1I85JkDoqR8Cwjg7/HDMs8JW6txAfYu/XoU8uo7FSX/5etQtg6by7TRG392qKKqePj1nsvuKRu6gu8D/+la/LA3IJOzGwTCsjv5Ok8nJgy6HjaZ2M6+gZtBHz0MZimPtAIJnrLoUVkgQuZJBGfZZ7I/KRBZEwV/dYmYZpdaneyTDESQ4+YCyX3WzdVdv6V3ayFAn28NYv5rd1Oq3JZnqHn3GsKtdz+MtUrQYtST7soSGy0vpGEJqo4q6w84pL2342fW25bxglT7QImekUj7fYw4Z1i7vO8l1udT+uplO9EA7La+5tQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 12:46:02PM +0100, Jörg Rödel wrote:
> On Fri, Oct 03, 2025 at 05:32:28PM +0000, Mostafa Saleh wrote:
> >  void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> >  {
> > +	size_t off;
> > +	size_t page_size = iommu_debug_page_size(domain);
> > +
> > +	if (!static_branch_likely(&iommu_debug_initialized))
> > +		return;
> 
> This still adds function call overhead even in cases where iommu-debugging is
> disabled. Move the static_branches to the header files as well.

I see, I will fix it in v2.

Thanks,
Mostafa

> 

