Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1538EF9D0D2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6255F6B0092; Tue, 14 Apr 2026 10:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6D46B0093; Tue, 14 Apr 2026 10:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4F36B0095; Tue, 14 Apr 2026 10:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC336B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:21:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D97148BDD6
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:21:20 +0000 (UTC)
X-FDA: 84657373920.03.AA9EE29
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id E11044000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:21:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tI2oyb7G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEiG0pv3ld45N4vGWqNT035i3YfDVVzkWQ+St99V2LU=;
	b=mlozo9vhZI2DmFHMv4rtJq0a2L03ovszkmln2XkOAj2CwyL/GcSyRqrTRLxum2ZvMgAdWD
	iCIffjdITgmBg7geZ9DOTwFMH/bA9SRTkXezlyEdJrB1ChZt3eFlNQFjiwjeFskrNdTikQ
	JCw0gD/qaFwj/C1gqU16udWPo12SAIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176478; a=rsa-sha256;
	cv=none;
	b=cxcpGF5ATKCJFMES6TMK4AjL5XnDDlpL+OeJWJMvcWt5o5AaCgu1Xo6LN1r/TBq1tYTGLB
	aJbze6ITr1Ie76razfJLe5YkFp25Swp6sVpsa6a3Qx3UiR49FNidAWimAncM9krWuuE/Fy
	XIA5IcxOebokD1EC3hZe6O5mOno0zxw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tI2oyb7G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-823c56765fdso3145485b3a.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776176478; x=1776781278; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEiG0pv3ld45N4vGWqNT035i3YfDVVzkWQ+St99V2LU=;
        b=tI2oyb7GmaJ8MH7Olgg15IXKIF0HWp5dox4U5Cs849BOSIO7EEYg1wWw5GrvU656Lb
         krIDZqMwi0YrNhsBmPJdlC0iL2gbsh6XfWvVKVKWg5ZlW/y9vZ6ocPitdELKIKfCwb59
         8C+gjPzeEmXG1HPEZmkasxrYV+OQ2M2VkvGzmtNg3AxVV+HqxHQCYuvK4Q9JyKH+8vq7
         jik+fYWOrb+V5w+Ufsh0dxZxSbMiSDSHQNDAB9VEsv+RbwcpYRMQwbf+IoMYsScnPCEa
         gduZlC9zYxNcTJXw6Yrl5brYYqC0456HW20EoHXsFNzOB8OBJbGMsjENpnGvjcDelX4d
         OF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776176478; x=1776781278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KEiG0pv3ld45N4vGWqNT035i3YfDVVzkWQ+St99V2LU=;
        b=M445nSWpBbsH45+0IVQGo33JVetX5Cuy1v9pmq+yHJlMOeBXV+l6viEBlu90qQ/1o9
         T6j5Ugc3vTdb9Jfiiw47nOQEz9U3HMLvqEjuVB6r7JpT/Li9JbCBTERHueew7ZE7g4jN
         NcSjYSBMlHZx+Y/mDpHPAbRdrqmCkR8Ix82DpzNRgIdiIPp3peelqandZRY7wpsAw7Sk
         0nuasBWvFBqCWvYiRbiZN31dmBp2KoeeHsV8fB9NPIB77JUrudQ/saede6sb+CcFycB4
         qecAdX+Rc0vhsoDKlJ34X8ezrm4ZgPKqBZs7t2u1/PzQ68l6BMn5wTrLQN067m/G+ODs
         X0+A==
X-Forwarded-Encrypted: i=1; AFNElJ8qxsrFMVfaFqJFBxtzJu3gwjvsCcofkHpxOlO487klFRRlzzdj3Lcv4Y+CANqP6bfqla4VRXSSpA==@kvack.org
X-Gm-Message-State: AOJu0Yy9GXrR9c94IScDqyrGQze5aAHaOGj6rn49J0v2DlZc2js94uhw
	lNhVW7kdCwJLpMzeu1LG8exaZGvNTILaXmWKjL1BPzGRRwnk9uSX9NzV
X-Gm-Gg: AeBDievBMBaneg2PReZMMA3mgMmPNox3T/QMLObktoAfI6HrKSoIHVidAXnfE7qq/03
	GYHJ6ndWNQeU4oNaBw7uqzGJOSld/tywJXEzjF9sm/zywiiHp+zzRdB6B367/SDrOf7uRMn8sKr
	pTSRCnkg1MXnzLmCAYMhNfAekYjjmUauf5z4c76f9MbeCpmkTr0CVDiTcT38ryVBwqjgkl4WWUN
	YrDRDRnw67VdF035KIKbUYw5zLJS9BDfVFZ6yBAH0z4Co34slC0waoCNuveLG/PNdE6y00th/2C
	68G070K72jHko2MHT079mmeLbWrZvSRKBes3B9mCNaifXXzmt75SySAoNTuaTRXfUVDWNU2ixg8
	cHEwy7vYnfm50egITQ7QS7WjCSzAm5agFLmcQiQivmMQmu4wS7ONwmYGhS4ZdyPVwYsl1jPv1YQ
	27tB7JLqHMeDbQjh9Ts0x/mrzjyuRvZyKEL0zQcQgBuLW8
X-Received: by 2002:a05:6a00:124a:b0:81f:be3c:9c9e with SMTP id d2e1a72fcca58-82f0c297e11mr17451342b3a.33.1776176477331;
        Tue, 14 Apr 2026 07:21:17 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.18.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f45defa02sm5939190b3a.39.2026.04.14.07.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 07:21:16 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	byungchul@sk.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
Date: Tue, 14 Apr 2026 19:51:08 +0530
Message-ID: <20260414142108.32108-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5914d296-934a-4662-b1cf-d0f23757df5b@kernel.org>
References: <5914d296-934a-4662-b1cf-d0f23757df5b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E11044000C
X-Stat-Signature: tedy8suai65tad5ay5ggp58jmntrrkpf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776176478-679298
X-HE-Meta: U2FsdGVkX1+ayA5qIpYxOnIF2vuCIMQKsbT8Q6rf5vstPDnkfIHnSvVGJxG2zRmWJuEnAOLIXzwnSOoWP1IijFrkYJLcgYjMk7tg6dAaJx2Yve4sULyuLaVrnXEEA6HZJjgqRVDV6+Y437mQy29WzyI0fXL4RBdmABRHqfKghJzspER0BXNs89GuxLsLpsRLr8838nXmDhDUSA/UZNo1A+1C6u24PTiIq2pF6RCwFKZcOlR0tRmrsjZmVMoCz2vSUXgOOde2mxLjtwAn155oEhDjRax6UBA174X3BPUFLKmiTCc5tGgBTkGhyVx+gyphg7KLtIrZqaZmd1M0tJJsBeMQNjNw2rrdZ1ZsZK19TYeqoq03HL6Zf7bB0U9e45DIFCuZ4PPt6dsuRDVsK0yeO2vx0evtLdMN8igukoyaNWRsQGugqkh8o2N5J1F/nHdNO5e2Emn9N4NjAw1tp4vwKWtEOE0xRs4MmYXxVqgG/vEw9naJbL4j2i7G7qb5d27rTpM7XzxSoVN1dL8W8JsF13y7ptXjWJQbNr8eTxLy/aSNQjgij4vcQDBLtWEVIgEQf3TFNTFHR8gz5hLOGQO9ruFPx+uxuMFaj/gaeUvvGxb+swwuvTzPFGbRhjAoE+0XIJTc7Lj9e/YdOeqCBE7T2iX/bemmTDfeq+Cn+JkS2NF9thbgobG5ipJIYIpzOSGkQ7MwfR0FccKt9sYPd7XTYNdEBccIAvWX+YAtD2PH8qJGPrByDP9hW0Sc5Cm3ckIuMIzJTBjHLdHNK8fVKD1kkUg0lJEuZaAEouqHExyLS89gn+SdwKjDPTKi5QqzYCT86SoTJZW19ZKqmZX21nQnxprAf+VaVpfuhxCU9mS4GYuYmfKRFQK3bjKlbq0xl0siEOYxlLIMuODwW+YrsoJZZyDHcxzXoXOQ2/CSFrCHSjsODZv2f35V7GeNBGn9jrEr/v46BuwJbxEgLJcaNIh
 HHQlg3hU
 yOvYjbVZYE2Jq1tZl+RtTcUhs3bimlae1cYGmV0LZoeq6FXwdlxMO1RXdrS1STS+oUuZMfXSFi9ecpf1h3kyoWz9cKJPtiCsRKwH+XVHhxeBO/W/4SpDCwwwVtz2c+ZCi64MoDM9LfXWkIhUY42BCcP8pkWgfdFafz/JguAyiP9e/uF7HCyE/FmoKApJ/UispiJ3wUygVE6apBoCLM98jcmiThmSA80ipTHiI8lD2VGe1EblErGQuaTBnj/ewmT13y9jpRJX+8pnepiov5EjvfRzJXvqCbGSBfmrTnfF/3XKoq3ft52sBk8MiLLZhoXVjMuwdIPr5/IEj2k/loUEAuPrtOGc+IUDenPt0+5p8lmrXzDJgPgXtJ4hIJGbP/Yit0HqPCzCdRUKw3GZG4Rz8DWeNIeRZ2pGv6+4YzEnlBcgYwXaUhjo3e42Hh4JzyQDRNLPSrc9vmMKQk+LPMOP9zvuz905sJVzZCHUNIF21ed7nzzhpeZYx2/82XWfIiz5j4vt+Ps46UkG7bkEz5P22O2G2aaLRRBQ3rg//
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please refer to below new cleanup Patch as discussed.

https://lore.kernel.org/linux-mm/20260414141344.29949-1-nueralspacetech@gmail.com/T/#u

Thanks,
Sunny Patel

