Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F77C531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238716B0093; Wed, 22 Jul 2026 23:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C32A6B0096; Wed, 22 Jul 2026 23:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089AA6B0098; Wed, 22 Jul 2026 23:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE9F06B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E405803AE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:38 +0000 (UTC)
X-FDA: 85018669596.30.B124D86
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3FA0D80002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mn9heTG6;
	spf=pass (imf02.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmQfb7RGeHqBIgAxcCBU2i2fNRwtMMc3p7Xugp36EHc=;
	b=oFS9g/5hoCawjwvBUXgxV3moRl4WIYbTN1GdbcgoRFVknGVgSlrRGYhR0+09jAZE6JopxK
	uOKkyRWqrWJVO8PWkKnEqyK7VcI18XoC2vNc7YUREcT1LI9tLhPSmh1T1lO4HEDz5TL2f5
	euK+R/oes+3QjYbeRTkMMNUPttTGd7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778756;
	b=AQZKB2WnIKmfquevDGHvwv7o31MBtYEnJbh+2jphuD7W/mXMi6u5FrYPtKB89FHsUvg4X/
	obz5jL+hYPb+F9Y0fW8qKS7YaR3mFIV+kqddjDTz/IG5bAV6lWv1VrRlXR/Iq2buzbvX5N
	aVH+irqC2N35jP9Z96phWO9vVItfQNI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mn9heTG6;
	spf=pass (imf02.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so137951a91.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778755; x=1785383555; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xmQfb7RGeHqBIgAxcCBU2i2fNRwtMMc3p7Xugp36EHc=;
        b=mn9heTG6LQ0cFH3nLUlY9FhHnGvVzZWMRP/wqZTN1iT7A77wLltz0L+2gF/d5dG4rg
         kV3Wj7mkO8A0a9jsH9K/9n5m/B4TkL80w132lZgk/8NOtz7YCK9ya2y7i/ELRGL84lA0
         DLagd3mh5EJ1FDWEhaW1DntHzl2fPUHxNgu2/u6PTB6OOO3wuI4jBLi8F21Mfh7dIKDi
         0BMrKyFyrlm5K9DK33bTENdGbVC8hRqJOx/ec6MtedF8blG4Fo3ob1cle7HJpniVnHOf
         tSQt3ivgiovMMwE+mQbmy6QCxA1sV/Mu3HNfH7/oSB4KoRSsxD9jtpEIgh0IWdb7I8fs
         Wxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778755; x=1785383555;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xmQfb7RGeHqBIgAxcCBU2i2fNRwtMMc3p7Xugp36EHc=;
        b=fo0MIYm+7/MiJj7xeWkAWeSgT4ya7LhUAPYuJ/AcRUJtrduAHyxFpqo/4LCHr7S8QY
         DR5L4DRdkLsGTti1Q1kVHZtVAXk9VTrs8mVDPAqXZkxoM8Yxbbcbh2lVitqF0ZwBmgnX
         VUHH38ZEozuOmd8G+V/5eqDQTk+ZQVUEqED2Y+0XIZ+oiFTSLz/6uI6wyAchlPmLjsDh
         46D4haV+DUc27+B6VSIE51YvjjP0L9PLwbui/GNJ5uW+nPcTxNInPZvPnm5QQmfVJot8
         mdP6Y0oFc9+anh7QkJgwhmJFzsNH1R1yKXXDc7KWbyfnU7qayytpj6VmOijtQwUFsdRu
         ctzA==
X-Forwarded-Encrypted: i=1; AHgh+Ro6UWQpoLuS9Qw/FNIV+gh3/RRjDAyjf9X3Nsnu+CvcLwCxc0Aj+2Hj0w+1L8GbMsR+9VKZUVLFQQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/wb+Vo5y2j5y9h3X1WKA4oAhBcR+eIVjTcEoRRATwEiNJj45i
	uRPV6RZEWBS58BCfZP4SM+tbMayrSdbj9gAlGaDSS8m+Qq8CJpGPLIFh
X-Gm-Gg: AR+sD12pJfGZTC2urkyXuceVKDVG6MDKzSia1jhH88MStwfpswdVlxzsP5x3jFN9ghA
	7k5kfnKR7u2BGVEIQKYiKS5/rur+D0pw68A9cFK9FoLNpf+LumaTDrwyLu07h4a7W5fGNARvvWD
	gnaptxu3hf44g2frHtxQgSzBA7gH6QNgvt/bkNxUFe6CNwdA08lbuIeGx+i0XzBIC9x/8jbrLHq
	sonh7tLZrXQ2hR8n0FAc6cH4awdOQolEr2hCX5AfUx7GXFxmyBGFOIiooo9EdRUtj9L8xh8qs9A
	RkQrSJ4RLarzoUf68qKX+tgeJc9YOpsVW4anE8NyBan1gpjnjcO+dqFGsQShRH6agPkwl8Q1K94
	YvV235RSM51gG9M+NK5cGizQ3y0D2G0eSm1593pjeZGS4M3N9uSIfngwKskmu4QKNkZZxqJKoz0
	Mkow/8gg==
X-Received: by 2002:a17:90b:388e:b0:38e:bfe:81e3 with SMTP id 98e67ed59e1d1-38ec6495a20mr1338287a91.8.1784778755164;
        Wed, 22 Jul 2026 20:52:35 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:34 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/21] binfmt_misc: require an absolute interpreter
 path with 'C'
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-1-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <20260721-work-bpf-binfmt_misc-ptinterp-v2-1-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872729.254289.514226158931792401.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FA0D80002
X-Stat-Signature: x6tcwxguc731ohq66pqf1gio6mskpfk6
X-Rspam-User: 
X-HE-Tag: 1784778756-405937
X-HE-Meta: U2FsdGVkX199/kLZZWIlNEBNpdUMCu0l3vMyEyX1lugbsedXx5/sz7FcjiZCvy6NzCxAHd2srxGmPIMuPRnzpreXuHSSP4rw93oHE9vtmh7rvywPw8RaBxvl+rUvOf6QTP9D3wGgtMpo5MWSsi0MgTiAzaVccJ+DSWdFiu1fG07o794aXZa2F2s8UOkLbFriguOgZrA5XkyATBNYbXXfuDD0y/PFxWzrK5Y3KFR3lfHS7iGCXCOUjDJAHjMjJasRQE6IGvxRZ+qdyitME2cq2pFpTXckud4wJGy+2vmI+sBkGBNq/yA4TDdzwFnqZygEM3fey4nUJ4Tng26ooGgwM3R/NtaisMUawomr4Oioy+VXZkjEBzHmGUcxivPd1NR52w217jouTeYbKydlThnJchWDVBXIIfhLnsSjgTT12NVP2YmpZLyK30qvQ8LxxBe2Hm9qNp5d5TEhxnxFq2KM+d38GOAJnklOsBv/M11PTiox0y1lsIHpL6vWbL9D43A//8LgNbEMI41w/tEdnXRlYqUW1Bks1NiI/Wbv87gBMHcPMGVrgnWlVVNErdCk8p3gKCiY8HWE6T4LGlkvftH0kFAPMjU31pcbzW2P6Asz7RdvF0zkkY3X08zXZBZUo/Abj2CzNaTHJGmC8MfBU8NBchRLmEiwGjo/7yWYWa492zjFPyPOE1UHm/TbTtWwdssXzp4AmvlXatJVMYpBfITaI9nqfP5PWMTpiH+QrGeSO2VR5WKljqR3FKvLKLcsnGlcENfLPXnfYMkYV1nCoHwdZca/jA85Q4oiatQ/bsxTV/rjOrMpYyObuHK6lBf/4CM7l/2LRVgX7dcbTiFKMoVF99Z4oMdVIYon1irzySBOEi2FYwvVGKXl1fJkth8VEUUu+2cvtKtwSxZBAH2v6A2CqeJ9+HvyJCEbdl/FKcBjoonGs8/fzENalMMEU167LTlZae43jBnPTa8v/4fzlEI
 G1TLVihr
 xyCJeam6GvTEU9IZVVYuJgdcbZ+Lor2vOBGPV6FL4oTdHIdXLxacp015koj/ruSbXQ+dlPBBfAKIxkmPJsPo+f4oY8KDYf1t/Qv4gUxlrEvxLvixqNd97DX7uLdWNfei/qvj+kUsdLLlDAqRhchNqEqyuil+vfNNy9lporz2Zto/okGAzAwfXPZiG2XfqQ21T1TzJMAbJRFcJ17S5ZHJHpUf79eMZFHaIe4Did389mWPyTV2uDID1C+szNXUFHqSOXRBU2iKRBbp7wGVduvp3lKOHH8X/CeEoAfX/Yhb+pczjNmTXxn6saaXYYN+/xpBDovsnTaEMOegjdX80QQpBS2vOhP06ikpIpR8/h/HdQ3j9UvTSk3XgwXeJwkVk8pJzGiyK/D3cW3+kjv5ZslH2dJwPipLoLkdtRVXUyZsLEyGZwtPaVBjIIqpoiNpeKwjar/l6wQ6u+OkqbAp7tGWhy3FJUteUrJVykRTiGPB2rXTOr8+JN+RWUSqclQMys/Ryk1gKZyURFrJ8RaUB7JJBpd4V/b2Xaqffaj/81NiMqAl2RiNubm5darToDwuAsBk0Qv9f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 16:13:43 +0200, Christian Brauner <brauner@kernel.org> wrote:
> A 'C' entry computes the credentials from the matched binary instead of
> from the interpreter. So a set*id binary hands its credentials to
> whatever the entry names as its interpreter.
> 
> Without 'F' that interpreter is not opened until the exec happens and
> open_exec() resolves the path relative to the current working directory.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

