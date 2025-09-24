Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72B5CAC5AC
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 00:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1741D8E0007; Tue, 23 Sep 2025 20:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A0C8E0001; Tue, 23 Sep 2025 20:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060E38E0007; Tue, 23 Sep 2025 20:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5D7D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:49:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78B7411AA5E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:49:01 +0000 (UTC)
X-FDA: 83922309282.21.E9D2A06
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id C649180005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:48:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CR1pYFT3;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758674939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=DlqXclLk7MULK4g2FGioSLBX0LB3edWSvQoe6d/teeE=;
	b=EVASo2E27aKd/VGDmPXxULRyaX8KqjnsInipEW5yMeJgOnJ7XNsO8gINaGCDA0IMX32ZNT
	svn74XSAeyFpRjDGDQ/RJb7yGNcekJfBLDXRRHPUZbuG91sNpl9YEeFB8HkS20WZioo2jV
	9Hcr5GrGmw3o8davcTVYK6IUNizc9aQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CR1pYFT3;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758674939; a=rsa-sha256;
	cv=none;
	b=74WdAnqbkGLfBcBiY+rkfRbdujIdoZPV9LrezfVR+PEzqAqQjZEieyzi6gRORCZUgglq6Y
	OHGp5Fnn96kVg6A87gRCbZDnfgRdO6IqLVwJh4/TkaE3T4oDqf4BZrL0lP4qc+SEjutS88
	7tb4Y0YncEGmyDNgJAGClVWoKSZ85Po=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b30ead58e0cso196375766b.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758674938; x=1759279738; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlqXclLk7MULK4g2FGioSLBX0LB3edWSvQoe6d/teeE=;
        b=CR1pYFT3/EvU8hPArSxbvWOwmL4u0rYVq8s6zeS4ARcg9YPGzJoEX9v9WiNSt33aXl
         resMNwq8l/8PeSynTUyU7rWK5/41WpDm9f7N+d0As136oDIhse5WdOpYW5ZGqZqndRZn
         HdJF2+tazp4rtLL8kd72JkmIf4Xk34Khs+L3cNzxGQaM9DovLpSrgh6fxhn4MKQ3IQpu
         LEZSz0q0Ih8lVwdzATg0ymylMNgLUYWQichlFb4s3IHcNXoN0jYefVGLBhX6am9w2EtT
         qSpiWyqiHFDjGHz/VOZEJasflGpquAuNJKOxDU/SPBaP5gEK04O7XEGq3hgULWcECLUk
         Qxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758674938; x=1759279738;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlqXclLk7MULK4g2FGioSLBX0LB3edWSvQoe6d/teeE=;
        b=DASYlfhXau/scEOzHGI2MbTR1aGWqr/aQfiKOOlBcfq8i3Ue4isaRIAtjeZCAMy53v
         6SSoS0b0MoVbsU54LeGnip3A5viawNGNDYTNlN5ubnMBXGw3FjJI8CViBCGP6V+5vedf
         +11Peb/L8K94CrWXw0XcIlze+L45wAm+Eip/MnfqlcEQceckpkzzVyEHJuJB+v20U7ht
         DtT3fzdTC86XGNHPiegOjs9YL7P0sUPjR1lDiXw7Z//LDcraAIlNuJIgzycum6QTrG8L
         OSL0Q7A+nJihLeOe7oQ0M8VlCCQaXmxmnc1c6oaKdyOZAcKqM7GoCkT6tkuOW3hyXjQZ
         X3vA==
X-Gm-Message-State: AOJu0YxOL2H/GEXFDcuwOnr5tw/LU+Jvsd+hmV2ZEEABrXRVF3HWOMav
	JFfhN4dl4/bM4nY5N6upSrtGgoSvc9tHeTmU3gq8LRdE1tF0DHzMnvfI
X-Gm-Gg: ASbGncv/8Ot4G2jm58Fk85lieIKHke1qJ7k8oU1qw5AGrutG474GGzV+MruItRGYzrN
	mXYZaHUqyGw9GneLCUTMrlgDkQLD613vRkTBlB+dBmtBASzS746nJOofDLj7nXCFv65gXgNA2P/
	dwjnr7tFdS6r0Khk+CPPsyEoY3UxjCYI1EpdnluzSf+hdMTyFkkxvbqR5nYrjtdQHXZJAo0mOQU
	XMMFgad7lELPH7MjYF86d+LKSx5NflcMYINWTDoPkq1KGIDYKsHTIZpl+HrEOcJQZom3rGRUp7z
	KeAPyNeARXdqIkK3yVCV2bEGzl4wXYAhusO2DPWrFemlA1Om/04mHmL+9JI0dz0KbgZ2MoXP6NL
	waXHyCHZVi1TCNCY87oX0qA==
X-Google-Smtp-Source: AGHT+IFxiQipMJgg9u0Nn6WbKDSXm9ir5JmFIrkoiUVaNwLRZAfhfkLqfbj8BtnF+G1snVEfR6r36g==
X-Received: by 2002:a17:907:9713:b0:b07:88ef:fe1a with SMTP id a640c23a62f3a-b302a1752f3mr503649466b.40.1758674937956;
        Tue, 23 Sep 2025 17:48:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2e01a7c046sm448864266b.103.2025.09.23.17.48.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Sep 2025 17:48:57 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 0/2] mm_slot: fix the usage of mm_slot_entry
Date: Wed, 24 Sep 2025 00:48:52 +0000
Message-Id: <20250924004854.29889-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C649180005
X-Stat-Signature: ee99cnuxegw4b3em6m4tkdbkrsawqsni
X-HE-Tag: 1758674939-273762
X-HE-Meta: U2FsdGVkX1/wIUeoldy3r7k90HCyNhwGKEgtUhFXMVZ6d/LFWwz2y3T/mKWmEI+ibBS+kB9vTPDj+4BlEFlVCEHKzBraeXDtNd9OyuJtrpzOyjtrs/FSIydaBWE4qi4RhCuLBkjMXeeFHY38HlqQNMhdqviPabxePaSUmyViTu98vxUPkWI+B8rQo9LCt/iJWTk/DxY5mNExW+16m4ztfrODew82mr/yDJ7/qfkWBS872SWhbI/jf1BIp1guaRcRVruB/fJXiQf682L68zR1iOHsT7YsOVRygAHFNeOo1iMXTVppgdefWncd/2Fxa0ueihDPvZ81A7VyUuFLuUKWbSUzYoygd4lkZ7MJKw+FIj3xrVj9+QYJ3IioXP1wlV13VBn9z+ODMhShzXIMOJX2VbqWchgz95jL7G76yWxxSkshVNKQflArPSxZPy1nTQLqC+pDBvyd2LgKZ8zVafinzCj4rZ2t4rJUsfyIZUs98QQ8zNRnUxfb2K6mv60HFnv5MYtwrb4tUGEGMnN6qdXHmkKOtWl89DWaO8hTDIZCrZrQaeOdTmqS/6Z25TljrRG5zL8y3LSTZkczHBhG4BZ/YnBr6fpkpXki9ieKJOfBM6ub+d6brTuo6Uql6I+I6Knv/0vq/C2kIwXlZbhfAi34bB7ljRGwWmaHgSzZOtaQN7wW8MDoeRPW7fNbjNeuCsypRa9TIHzfj1HUb6H5A5KHTXydvCAjgxGki8azWfzE8ceQuXPbgtOg4Hka6P2vSwB/LXRpaXnBpbUmG6Mjf9yJt4cbspEJ34h8HSr+p1f9LS+3NcI4N/ZXQJsrqjxbehnUjCP3QFEWaN5d6Phr3K7+cQ/0s0zYRSWCTBGTjnkjxRBPilad5SBPabp1uLRFTtI9o5X0porOEvtOloP9YMt9a4JENITb6oOvAxdoo0vVSzQrb1dgWbjSKVQl1Rlf6MI2c4RZDJrKzQfGxoRkVwv
 3lqeOEwC
 lIkcF/Q1VzFuOmK/lwZPuYv+Ix/etelYNLnv6jxo37pgk6uskP3Rc5eYJqTmF/fU4oUpjW9JDZOvzHKloGb4K4KfOCC/Ul6DngBSEQ0FS5D605fCIVUIoAATc+fsn7m4Zlf5QlruzTe3YTVQzbh69OHsf1OhI7JlNUjiPiznRrRjoxuFFayQZoD0aMjYE0mikMrmx4naeQNKmeSBNsDNk93DbI0keE2OhtUegYAs6OYIeqONyheZ1qqyua5iFsJlBgxvkG8gEU59KvE0OF9scAWwWgJMOYysWdWk2vvZp4hON7CEGIO/ro9BV7WEsHGEQaEwkMvPuz7S5XGAZMRRvUmDuS7ULU6Lje9HwJfboDk/Ah69PxSul52KpmHTWdaHZSzl2NwyfnJ16/7tuy1C98IX4ZezFRi92VFJZpcW6HXktMTZd9Ry6rm9MP4FVfRUm3QNQcjYV9Z0YGdkyWLqscEL5NvZV6YHgx6nnswrE1YXq5rn+ffPC44EeWoHW8vq47Xd+hJLRhzRSW7zRYzSLY+tBs8k5sXEC53VcpMSK8EsFaDqlHr/APfsfiZAUR1grwEnV6SVpxnA27njlE+eFscyJsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The usage of mm_slot_entry() in ksm/khugepaged is not correct. In case
mm_slot_lookup() return a NULL slot, mm_slot_entry() should not be called.

To fix this:

Patch 1: check slot before continue in ksm.c
Patch 2: remove the definition of khugepaged_mm_slot

v3:
  fix a pf because of slot change
  fix uninitialized mm_slot

v2:
  fix the error in code instead guard by compiler

V1:
  add a BUILD_BUG_ON_MSG() to make sure slot is the first element

[1]: https://lkml.kernel.org/r/20250914000026.17986-1-richard.weiyang@gmail.com
[2]: https://lkml.kernel.org/r/20250919071244.17020-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
  mm/khugepaged: remove definition of struct khugepaged_mm_slot

 mm/khugepaged.c | 58 ++++++++++++++++++-------------------------------
 mm/ksm.c        | 22 ++++++++++---------
 2 files changed, 33 insertions(+), 47 deletions(-)

-- 
2.34.1


