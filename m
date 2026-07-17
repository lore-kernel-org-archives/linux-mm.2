Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BDDC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 23:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5636B00A1; Fri, 17 Jul 2026 19:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67CFA6B00A4; Fri, 17 Jul 2026 19:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571A06B00A1; Fri, 17 Jul 2026 19:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B01F6B00A1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:32:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC07E402AC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:32:21 +0000 (UTC)
X-FDA: 84999869682.09.415C909
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0ECD180008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:32:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CNm1RyZ/";
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784331139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+DUQOwOw2uIV4ajc2HeXFDWOg42tRR4f3JX3Z/V06A=;
	b=iJAlysz5XD+C9fJv6MRU6HdSKz8AHShxEjZ943gBkRI4LmMn625cz2ygQw+yylNZoQoEtm
	+4xVyOY+vlCklizT7dWN947P2E/308a1Usoi5Mu1hS00sT5KSzHYBJtcHk5jSztIyBdaw9
	7brPEg5qzbIOsrihqzHLf/gQoCgSQrI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CNm1RyZ/";
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784331139;
	b=yTBY5U8JU0z7jy8nyB6eLbURR0WMwLeEo4pf+ppJSL4s3gdkndUqO2lRXzcJFu5MzYEJzh
	39LpCS4FOr7jWI+iLVYtMBYxd4CI2Kb4jtABAu4Emml9lyGMDIp3Nl1Nra03ZzxgEhP1rr
	NK7KlmPU05Yl7BXd4GO3KSOB3+vWHyM=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e6391b114so412204785a.3
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784331139; x=1784935939; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=R+DUQOwOw2uIV4ajc2HeXFDWOg42tRR4f3JX3Z/V06A=;
        b=CNm1RyZ/cvGZG+6FBPS5iJjtvYJxh3UgFlgbMreEGMisfA9se1ehdsk/txNRJngZVq
         rzPAOfuiytwjQlR8fR6Tz68qR2GEacaG6i7kd525vZWFJLwIy+xEvWr/7ABNoM38udE3
         Oz/LrXqWNTYFux5tfRzXOEvkEWB438n3B0knnQYaiIV6i4TIIspqd2nTB2LDzYR37UM9
         h4Vp3yawMS1STsAYOOiZ0Z4MQw4aXyWTnbV9H5ojkWygaULb7wgKIvKyi097NAmtMI0/
         q99bogUSqKPwHzA/zL+6uLM6fcIbsHO9SvnfP54v8ezUAK0+BVOfTLVEo34t5hExljug
         8f3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784331139; x=1784935939;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R+DUQOwOw2uIV4ajc2HeXFDWOg42tRR4f3JX3Z/V06A=;
        b=KsKYqgI4Cw76GWX8ii6g7YXkGN8Guh9+GnfBs9q+1JoXbmiJMCntdkj4AkpVFaGEl/
         hyG9DwuyIOniDYxcn330T9ADVRDG/+4SGDhoDmEYriqI1Z2837wCmgNKk0urFg0yMh2B
         CVb3ICucOLcgF9FhrEGUSqr+cyIec2LTOA2ull2WE+mhJgJFYk8eFmbrK6Q7lCUM1SND
         i0jIzTgYhe+AQyy39q7imnTW1DMJhXBkvc5hLoVA3sFpZ9W8+pvehQNGgKzZXvecASpc
         F0K5RfVopghUvdpFiVXzR62eLQ2f8kpykZr58hPfW32DfcaQdpGZyyKJlD77GM1qsawF
         cJrg==
X-Forwarded-Encrypted: i=1; AHgh+RpOGFPVI3it1I+XkM3Hs+8lFymJmgZm5A8h+SWqBf1OOCruQK1p5Frp2p9LAmJ6wspuKEzQ40UeTw==@kvack.org
X-Gm-Message-State: AOJu0YyjMPibQrPr2NqS5OwaeFf9f8UVXjVRw5tBxeY2XVgARFxTuUur
	4Oopu2azbKgzaDx3LmzMur0kMcdZ5OAnMkugK4onoH8Izz8z9EmdMiebOYhV4mNkQzk=
X-Gm-Gg: AfdE7cnKQ8iFR8/Z/wCmUAnglHBWCm/ZFJPueIsuMH6T5kaYuzvtQ26+jShqCgEQ+/2
	1R7xshpswBedZt/yUqiJSOYmtuq/gZkc7cxja3pfZD/y+viVLirTcpH+epAZOsmhl6keh5ISzTn
	1q6sCRHY2uDAUFRbOYG+UnMSq5zYlWJp1ZXF2kQ1cnqlhk07DWZmKBJYElJ4EJ/eUuX7kZ/Fmjt
	Tumx/jzcZcChCBW4pLG6hTxO0FtjCdyvv+++zxC4IEsNAiNp0/gUgwk9matVYAVJewU0gISznaH
	mxgdDMt9MMf8e8Veoa/YWubSYD45YMwQWo0IqbWhWeWjZ89SHS8g7Cn/+DOI5uyuVrvfvpCFykZ
	NZ6j77GyXfKgKa5V2U9kTdkL8j0PDujB27nezYbWRBr73nOorIr1/cciOzD2FaqT3DBNIGKLJXM
	zOUYfiVwrc1cRDBu6op71kuhhxFeGb0s/Uq18ltOM=
X-Received: by 2002:a05:620a:472b:b0:92e:f3ca:2ecd with SMTP id af79cd13be357-930b41a0733mr524243585a.60.1784331138856;
        Fri, 17 Jul 2026 16:32:18 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm279957485a.35.2026.07.17.16.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 16:32:18 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 11/12] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-12-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-12-dmatlack@google.com>
Date: Fri, 17 Jul 2026 23:32:15 +0000
Message-Id: <178433113516.189683.9930130364443329744.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=563;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=s0LMm+OcoPpmqRB57FW8WPIACTHAgSpt/ofOePUvqwk=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWruB0abwGG0XPrEN8HQE9RCrgd8/buD859gp2
 KaKebSgf3WJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalq7gQAKCRC7dyhM23N6
 3mj7EAC6bErgn8QbHlK63bz1p0Z8+rEQtPpeKYfyZoG2uWv9cDi5gkXPAA2cyXTEg8FWk+3dxwk
 y6gytV5WrSayDd6GSc5dQIvNqT/DfySvbzgAES3hjQEYplR6GGXtAvSOJrQm3brDRl3OO/+Jyt/
 RWwegnDu0EtMTwd45jI8iO64zYNbU6iXPDmoo6XX85I5an+0rvaOq2+751osnajpvrUctCRX6co
 rct8df07a7hqEr30tX3CdeA6FpiPhXcSZdcc7Y/mdkIvSPqDsKQWLerNa66FSM/YWQRJyQz75aK
 eh1RdPuqTNnMgn57asyEoYg5pPIxn2wSy1R2+6bmZnsj7Bfhs8kivkdPulT2cq/+tDvb/i1R8cg
 JRhN3kONqgHydgwy6TrTDZQzDKLE1v70UqFkEmihAIJqaxEBEeMylAu3uuCt/3Xf/N8ePqlq4p4
 Zl1+UFEzR12poe688gj93wg/k5DYz12wvCyUaVd1ftxDmqLc5IbkfD19MjDTMA2VHhZ2dygKp+5
 jBzpCI2Ct6WYvMfudLSRjaT4vueHL50oW8vh8gE2xIOaoOwkDXSTmru1jcXLEpWZBDxDnjbHWx2
 A8HHgGX6czH1+b8pT3wyIyMQzrFYbow7ruhbDMctEsSZ9cOZE5vkRTllxa+Bfy5AWxoJFldiSFq
 vnDsQy6niCySu6A==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B0ECD180008
X-Stat-Signature: nofbokhr8ecizzq3h71rfzy79mudk35t
X-HE-Tag: 1784331139-552856
X-HE-Meta: U2FsdGVkX1+SQg2LQJ404uOS50/uFZXez7LT0NTGAzvu/e59vIzfpYPDAZ7VKb6tSeZyylsEuuB+Aygkd29Ni38KiOKF/uxiFUcbjMVfMOeeA65OPouz8E35c45WiBPxc98WwxK3NkTMTRK4oiuXLrLmOxiTglNMuSn8VQ9YAo37sGBIKQCzpQMSrdhT+9Z2s9hhjZIdUn30y/pBik2R8GVgHRgk24DiVaGlKr/hbBL2WoxHUCtshsiDfXLEeNGQ46J1l42CpR9wPkt+0YV1rGqJH1oltDXL3O305a4j5WJr2z4iry6QnSJsq7fIe1/ciEE0luOiHBKGlX7AR8bEd4vovYN3KVMfwtOu1XCKPGxum5Epdyn1FDbpbr07s4CP/fOfvE3qAvmuRuyRfomipGU8rgH+s5KdWqLHN3FGizc2tey7LHattgK0gYCFkE82DxJjvtCGFuqINRa8O1bWWk2wULUdmSs5XtXadReaHCmJSkAyBbHWxIEaR4JvR2q3cawQYu8DZ+xn9nxoMz58Q/XO9a7v2VE6BO/pwPKw9JWlL0YheQ/Jmue1bmGQXtHlSZQ2KL/FqeUTiEmlL2i5rJbk6LgEn1O7vMCOAm9v9h1gnbkVRjkXadnpzj1vXydeCSVJj77KNVGNe4s1YPxYaWN6dFPwTzOSQ5w21eKiorQCaukr+sh0dwsGtnMhQCdAT4K6BfLnIh4ARYU5SIoYrdkyDTCyTXF+tsQCvdr/vZ0qlH++kvmlj3yK8nT8d/NZ4hIAaC4ofbvU1fKhraity75v10dZyJWEzWY/DYVzbj3Zpip8rB5alpQPWTxNW2q1peHyQOZkayyBABLM0i3jiVbyXcDfz1Hb+WLWYIDx9AGJn8nEJDHrtkxL73J0tUAvRjM9LLZr/2bjkuSJ8eEb84liR5RkXyey8N4CB65kfJ1JDzMqj9HqWL2Yp+zbuLvatSZFno1TnKRWbSXwPOp
 LuTRGinq
 LyXZA0RlceG+EZ5eYFdTv5jGoNAxGugFLUJYntievPO8nWWhdsZJifDhNxcI8njD0v1zKR2oIBjZzVk3mVyAEnaDepEsx2xh8Zg4SEual6Q38O+Q2JRzxGOXeRlmYjsD18E39e1lWcDdTN+0pfAqSSCt089tNDa/FwsbQoMuXXC3u9+dHMsJjq8eH0qEZVQVU4Xf/TphBS9RqZHRkfR3idE6Lqhyhq9oR80/ddwdz6Df9e1Ks45DhYrHN3inc2xiwO+GMmbP2osOhorA8QueSk61YEidRqQt0luK4xPfbIjNymB/SxlyBpoTBPlbMJ2StlJlLexm65nVuOKWdIrA8/stnZWsBZfeFb8zvjBMYHRwA0nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:14 +0000, David Matlack <dmatlack@google.com> wrote:
> Do not disable bus mastering on outgoing preserved devices during
> pci_device_shutdown() for kexec.
> 
> Preserved devices must be allowed to perform memory transactions during
> a Live Update to ensure continuous operation.  Clearing the bus
> mastering bit would prevent these devices from issuing any memory
> requests while the new kernel boots.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

