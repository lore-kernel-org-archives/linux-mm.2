Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2CE606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KDG5+upo
Received: by kanga.kvack.org (Postfix)
	id F2E7E6B03A5; Fri, 23 Oct 2026 11:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8B46B03A6; Fri, 23 Oct 2026 11:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79986B03A8; Fri, 23 Oct 2026 11:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A49B46B03A5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:22:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25E9116014E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:22:53 +0000 (UTC)
X-FDA: 85354258626.25.0D2202C
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76B4F180009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:22:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KDG5+upo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792768970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4diYte8A4U+5YdamvmyB/opU496/bYf8sQxy/1ok8Q=;
	b=jTyYxB9lW9bD6VJia/AkzPVQZ2Wfcyh1wxw+bNAbt5T3s2y/hqudaien/DlxZDO90Y22r4
	0kEwW4YIEA0rkqgrVG8DcilT4y+Sh14PL9yi/QImSioCLCBM7xlykaQT0CX8gXK97sBw13
	GyrFLEdFnYWxydvCwFQBy9f3MOnVJRI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KDG5+upo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792768970;
	b=an2PDQwuuflZMpTw+++wO5mmXWETtiMEARIQBoFTbwIi78Y4oYqLEra1t8Sl1NFi3zymL2
	RMalLvEuYoZG7Pj7SHZgrXrj8pArL2HjUic1eGNG8vm3Z8xFk1uD3lzeFc0KM9/BIEZ5Eq
	Dry9vs4OVYx5xc2nqJTcCydhnT21EBI=
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2e934c6c20aso6466555ad.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792768969; x=1793373769; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v4diYte8A4U+5YdamvmyB/opU496/bYf8sQxy/1ok8Q=;
        b=KDG5+upoem2fRf9UsaZAGaW06vFTHQOJ45uQMAd3+JQI2Uj+yXQi5VkIZtPBhNM7y6
         RY8YzzLoDJfaodAIOjBENpMwOYHiIRSTPcNx+HFCelkxwFWXx+IaFg37D5VwfroBblUA
         hWYQi2qg1JhQLKHFIrxpF19WAXVzZCxE2ti0DXz8cg6ubtM9JtLzha37O9vqA+W+01pP
         4GvmK4S1U3sZE2v8sDapsqAMLGb5RBmpxP9aTwj5ro+j96mf+tZbqNjLErhYF4j89abi
         j9lfJ7uj4dFZoHTjPFWV8BzyBZZ5WTXZHC2LwVXIAk5kLXqXmY9zOgK8Q1ZwFI7yZMOJ
         ctQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792768969; x=1793373769;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v4diYte8A4U+5YdamvmyB/opU496/bYf8sQxy/1ok8Q=;
        b=F8xQLPh/QjWlAEY/gRQiZS1Vc+EzGOrGfI7tPr5KSZQ6+UPyuo6gSe0m2OOYKd2kmj
         /bYUXTFcaIoiJgp9xJRreIi1KhdPW6EgFQvO+0HslmLvGLFk0EV6A6GP+mt8vzNXx8R2
         PM/BNugAfvTTSCp7Ghsqc+9HmNN4Wi3jisDjGnlX6P0qMr5xwhEQlfBKJ54zW2YHU65/
         +lToWQ2xfvaN8jryLDvPhZSC/p3/HUzVS6jWlMJW48zGazfzuFWur2/tn8fs3BusudXA
         2QinwGOSFW7FyFZG00PPtIsQx1PDIDqWhTKpZvUYo4mf6Wp7KuDUTt8yJf843xcxSLLq
         czXw==
X-Forwarded-Encrypted: i=1; AKwUvBzyG4WMqbjrJqEOw0V5XcvL1sP1UsExl+GUcg9P1wOc7pVLwlL2xjx0PDfrH5Xy1FuzDAO1w/vFIQ==@kvack.org
X-Gm-Message-State: AFq9FYJ9docZtGr13iZh5+m8RiEW9pDQ0Ns5Se3zwylOG0bnf3FUw5Yu
	c5qNk5ymynSRrhNYYfgr09T3x336eeSOrAG8DbFiHfN5FDl5pYBeTAS/
X-Gm-Gg: AYBFou3bpICYrYZEycC9C0mtk+Qvug5TVD6L/z3kBZNNYnsMQmIksT1MQOh5g7/+aub
	htHVYZRz/GfJn5SoXDS0AZ8Y/5g/yiKfYxBryyn15sw8m3AjPe650y28ON+o1O0wH3nGIYnLEJQ
	io9EYDK5JyH0gptOfYvq/2VYEfQhP4t0IpVVy2cH8Sok90Ycs2HM56Mr2vguqJ2kUl5C68jh7TX
	SQTy55UX+k87xF/5pehKj8L5hhXquTyoPpUu2TGhVjTtBgGvlOuXofAUYNU1oX5mPBkJKCi+zKA
	yw3mfNRgnkxR9w445uH/KizOcEOpWpOxfiIJZHUsHqcyYjEHOo/YbIhG9cGzsKevl2yIR93e0hD
	wgoOFA6hgsD39dibCNfJ7ftAL+EdDmhtxJRjYAYq6S0+mXD4yfEiuLvC9F17FKAtMtfwDDeBM8L
	uP/khspcUKKNMoi2glKOB2y1Vexkk+InMf+QVYHXOIcLEz9VAPnd8RYORZRoLY/5495h93jbDGJ
	ohBsvuXEktk8Q6BGPLskoDYQqM708klD+2nRfO54jQoa3W8k9ZQwG9sn5vyen+ec1c8NWU2hzcx
	6wrI3tYeQcwUOAWPJrVAMcab8Dl60Vo99/6F3PvKp6o/Q03nftpM
X-Received: by 2002:a17:903:1585:b0:2ea:1b9b:b946 with SMTP id d9443c01a7336-2ea7d09d3bdmr25679205ad.14.1792768969109;
        Fri, 23 Oct 2026 08:22:49 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9476f72csm1528235ad.43.2026.10.23.08.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 08:22:48 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shubhang Kaushik <sh@gentwo.org>, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Fernand Sieber <sieberf@amazon.com>,
 Leonard Foerster <foersleo@amazon.de>, SeongJae Park <sjpark@amazon.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 Christoph Lameter (Ampere) <cl@gentwo.org>
Subject:
 Re: [PATCH] mm/damon: align MMU notifier range when clearing PMD young bit
Date: Fri, 23 Oct 2026 13:01:31 +0800
Message-ID:
 <179273169185.2.1655708299473876346.damon-pmd-kvm-reply-draft@gmail.com>
In-Reply-To: <20261023002018.102560-1-sj@kernel.org>
References:
 <179267916870.2.5637290691657871645.damon-pmd-align-draft@gmail.com>
 <20261023002018.102560-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 76B4F180009
X-Stat-Signature: 5rkpjaqhd8mprskpsykxa75ywc6e546s
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792768970-275381
X-HE-Meta: U2FsdGVkX1+sHdozMDAXdUoIxRNe0clz1+egSLNUdNsdqWovwHlmKNEUIBNbnEPwRGLeznYhA+YXKR+iX1BWDcohbwk8yiFSTq7ChaLxvg0F5R0QTFzEUfmR5hCnGo+eTCqaziz0Fu1sPgwM20naDJOVdrw4igMwxrEt4yrQsVdH18m+SwTrn/WqlQB2W9MoLo/2SmOgzuo06ehbW4cbyUtCUlFwnnaXt5TeU31q7mo3vpnsOE9eSN/US6ZVnE4bfsfWsfBNMzgNRAwxxARbVd704t9RqclPd7iP9gHepSpK9lVaE+2cJxydS57QIXLoibyctF+n9Qx89I3VngF0LJN6wmdwf2axY1q/tyWRFPkmuRbYodgII1RPhHDHRqCDNDx8cppXIC4nU/gWYgkIlHO8x8r9ciuV1hwNA0/v9XHuVsm8j+uuLM6obRfTnqL7P5dvxWIRSgrnxS9qFBA8n7/AyhxkyuKHMSIo0IDDVEiRObhqLsPD1W9906Xxbo+LiN7tLjLowmlNfL7By2AHa8PBLwRA3H1HBV5SnAxoXd/6nl/j/bIQYoTkHp0vU8RpOmz0Dajb8KzW0YuD6JraJN5SZ+uCmEOJjqKF7VmQnLSv15AIvJZL0VFtKc1F8fNGuSQxz0adLIC1BdAw7PQSVUXSmIsgKdKavVo767D8MvZ+c8P/Pb7AEt3fH3YR4KENfjYVppwYceV/rHozTWUBtBNxYITbhMYwd5Ma8AmSskpFJu3AvE6++BlJ6AiLCr0c0rTs38Y3GLXx2k+DYnLfyccD29cbJVWuNPmYP9RJusiz5YOQjKX9tHPJdKQnKpxpBDIbgNbGjq3y2m7ewTdXgfgsZ1nQFZxwaQWLoVF39G5cI84XgDwVoaB6Ftg22D8EAOnxLn6Xynsw/GMN6qJZvbxX+PGAItjfn/gz9q0jUFNw3wvku1pb06i6RQLFZL/kox57E5yV0eTde3zBNv5
 HhAlh46o
 b1fdY0UCE+YLHCLNGaPydwafrIrPQepb9kKwkj577wslLuhS5gcOxD6oGxSFvfWku6htmwehHUu1CSYqIEGGUJBMD+N2ct0ca5mZ7x+KbTjjdbULTnW5+GoeRgri40nyQnViw7xOqb9RrrIrHXwPSYRCHn0utc5WZdIzTRSYsfcrTs9rk+w+ndBxHfoy/bbCuOGEZ03xm8NsiGxgZh8gJGAWrCrxc9bkDD32iPtf/y0QlUrDRq92SpYy+o7JlRN5Mq1xMGDcnba4CmzYxFBTOxEIwPe80v0xHzcrv3IA1pbmWJEVqmFzYKsLhh+uvV0o9/ba1ffBMw0rmWrC7vSlQdEYalf3DxeLvfxQre9WjMVSzzUAyAh52nW0rmkpqgp0R+XImEoDwdL8Od1dPeWcPkUff43cuTT2UhDrUzUeDBbdClLDOZ82NGy8YxBmHjyGQOCHcIOLOLzrTCutFNwmP+9IfYKBZDZSabiOJi3NOrol/2ELBHJc+Dd5Iy0Ku2N5ywIrGf2G02X/zdpOwUSEBM6SDmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Thu, 22 Oct 2026 17:20:17 -0700 SJ Park <sj@kernel.org> wrote:
> I Cc-ed them.  Please Cc all
> recipients who get_maitnainer.pl is recommending, from the next time.

Sorry for that. Maybe I will use b4 next time :)

> However, I think this patch explains its context very well, and therefore
> this link is not needed.

Sure , That make sense.

> Were you also able to confirm the expected wrong behavior (missing part
> of the sampled huge page and age secondary mapping), too?

Yes. A test with nested x86-64 KVM confirmed both effects. With
4 KiB EPT mappings, a midpoint PMD sample left the first 1 MiB young and
aged the next THP's first 1 MiB. With 2 MiB EPT mappings, both whole THPs
were aged. After the fix, only the sampled THP was aged in both cases.

Thanks,
Aveline Noir

