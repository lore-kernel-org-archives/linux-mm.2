Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8647D606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=miaQofsm
Received: by kanga.kvack.org (Postfix)
	id 7231A6B05B2; Wed, 28 Oct 2026 01:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3E36B05B3; Wed, 28 Oct 2026 01:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2796B05B4; Wed, 28 Oct 2026 01:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEAD6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:55:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 333811A0BBA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:47 +0000 (UTC)
X-FDA: 85370973534.30.BD4C9AF
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3793114000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=miaQofsm;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793166945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLkqAi8ctPqSRIwXUevfGPv3vaKrwbjwbnl9pr4s97k=;
	b=01M9dGoUfRsOB+pq0pkHyKDewU5O7xGp8LBXkAeg7Y92DadwMPSt1didYyzGiI+6TJtexV
	AbVlsaS17CD1xxGxM985Scm4wllpHXbvbOWB2kS+maue0LytYnK7mQgB4hRzb6S3hUhXI7
	/fan989N9YXiN78lBqR0CpEJ1siXoVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793166945;
	b=o8uGAU1GCGUVoNUc2i9HMC9k3eIg0fr07BzDFB2p8KlVuO2NZxv4l8iBknS10VKeut0xH3
	Ssz+bp/CZX/TmPxw80tZazUxFE8Ml3UhYvTlMggV1pc5x84oB/8sFlBjqZSRTybtwMYier
	wJa8mXKZNMaS1uo2P0N1TG0PkSxet6k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=miaQofsm;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2eac4877accso1798825ad.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793166944; x=1793771744; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hLkqAi8ctPqSRIwXUevfGPv3vaKrwbjwbnl9pr4s97k=;
        b=miaQofsmVG8ORBXjziy66JZi1ftfx86DjwFZdiMUnR+dA5KGJx7pP871ZV8FHWZvJN
         ESRISkGsZYW7O6X7RlIbYRVEPSXNXoltjicJUI2ecX8VbXK4Do0DfSbY2nZB0u39hAbV
         cKFhsX0wjZAIMbU0oru0vgyPNUOyrwH4BUHqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793166944; x=1793771744;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hLkqAi8ctPqSRIwXUevfGPv3vaKrwbjwbnl9pr4s97k=;
        b=zpJ13UDY0ZBMKSWL06d8XM+kOR+XLhr+vYrmz+d/KOMbzJ+uKpgzuhnes4k+djLlRo
         eWPNol3xEgrM3i+0UcfO2POVli5CbhcVM0wN9tYgc/c3Vc1+mx73R8vJQ3jERDijgCM3
         lOYzW9BBx7rpXWxyXflzrWLpJfC4nbcgiHRFBVBnhWuSG6jWM4u6kiANbgk8qZ90Mwtw
         IkteaBh3olKTxwLKBjT5SPUHLureRzuw+EklNLr89Yg3K5MJe1E6x5EN93MSK9Bhmk/t
         XTAcTnLXSVq0ji8/abqVC1CPVpy/3uFbOpUb+hcTtjzyzTgeuUge+TUwPgoU4GIXWL08
         DUWg==
X-Forwarded-Encrypted: i=1; AKwUvBw25J3IdeMqY8CfFYGjkPUQ470ZJh9eNuNINNpRObjHkq27pzEzoTIX+5BFUONPMIy+ifGc6fQTuQ==@kvack.org
X-Gm-Message-State: AFq9FYIDCz8wRCz1/bYRsKETw+6XSjSqlFozeN2AzenHEeriYcHIqeA7
	5rc0WgqjhoL1fbWhkRDJOUhyxHdElJVHsaF/kHIBHveij4470TbdAEKIm9E0f2Cl65k=
X-Gm-Gg: AYBFou15mVOlIwx7B0OJMd3UMqZ8jUTqtEqAhPPt9BvLk+vio9psrAs7Oky7LVd8rOd
	xueFHeDxNXtVLGesF62p1/sOQlagWQEsbB7DIBFNZwW5SL9XePsNXXgd+ZVvrLws88rQErGrC2t
	hiFZH40r6LUrGs7e26ls78gm2UiTzDORYU71T458j1qiEJgz2eRCfGj3nZeipBpc5DuSnh5DUu9
	AwRVYxcXqkJ+kc5GPR/AKP4o36fD+A78+cC+01STvXkXbFWFJCJcszR93koEFlyfOOmG78NelBi
	D0DKc5jUt+AYWmE/L+oQxPdM8OHEeC/S/IRyHXOOE39gNt/FF5o5O/jmKxTv9pPmPjKXnH3TsOE
	LQbqU+F6FNu41j2ICWCaZb6boaKoSaqdQmSXd5NwabmdrXc1f23p1PKIT5q3PzfCbcTZ5i9XufS
	Hjh8A4PQTI++Qe3/C2o+zvW8NtV9F8JMgjMyXSS7k99v/QgDW9PeBTiTfrVySA4eGB4PRVccEv+
	vMXGU5FXqc3i9QaP5+jWSHdbUbncSjxV9XIwaaBm7bBr4Dl/NVYWkbtL4Yd+rkE1dvO1nQfVM8Z
	ULzOF4vVmgQxnP+lklAKSuhDcn1cA+oGsq5sqLyK1yNkDg7ynSCEJI1bzvjiTkV93XoVcrguJsq
	wGc+PAJxfTAQq2+tZ2MsVBulhAgdchFct/AsJAxV+Ez9NM9eNX4R5a767OwYQ04BwtpOhaY+t
X-Received: by 2002:a17:90b:4c47:b0:3ab:1af3:a0d with SMTP id 98e67ed59e1d1-3ae5811b551mr920591a91.33.1793166944108;
        Tue, 27 Oct 2026 22:55:44 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9019a4sm1368356a91.1.2026.10.27.22.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 22:55:43 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:55:40 +0800
From: Chris Down <chris@chrisdown.name>
To: Jeff Xu <jeffxu@google.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot
 parameter
Message-ID: <auGOXLB1XZFWcTfX@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
 <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin>
 <auDTMb6WMFUpxeZy@chrisdown.name>
 <auDTptDQsB4xBcz7@gremlin>
 <18e2972cb8520c2e.3137322e32382e342e3434.279dd1.0000sendgmr@google.com>
 <auGNkhSHpBRd2U_5@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <auGNkhSHpBRd2U_5@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3793114000A
X-Stat-Signature: tx6m9mx761zpbfcqh9iwzds9hosqmeae
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793166945-624661
X-HE-Meta: U2FsdGVkX1/Yqn6aAcINlq5N9Yj7audWCLLWl90YSU28Vvhld3n1hODLll6SXgRdED6MNYGaqZThsexgPuZjJOxl6E4cCpizv9sbFHDaJkdwtFOq/IgFYIbzo2rtzj5/S4yxDMaZXVgz0+a8rhiZg1vN/fBnQwyhjraPnE+5qyCbfxc9rPM6CUrQKM4g71HYed4ozB4LRETz3iMHmAv/eyTDsGws+8Mztvjd6JDslclhiN+ntisTys0oqtX4n0dCMD2OwT/XzVvJPGH8UOiQE/p2zLrOEH6GVVPPUW928bCqaBS1QwVVuLYjHkFOOjghFd1XhnZIoqnUNxxrO6tw3D2VbfcSE+6UXZlg3/mM8/QRXvni9s0tMADaNFQtalETD8tph0pAe709iuwSdaC7HGyxS/vssFwPUty3K46E9zsOWAv308YHoK+zRhKbqOBy52WwaC0X1cHYKE9A0LaodHA3bDovvAEyzC7n+TUDbnc54QU1n89TzCDkVqqJxEaPpJtitI8S/j4t/550SU2Gp5cvWtVYQUaQYqL1HZ3J2kBx4M/QNuYQAIDr10hQYNsRw46Kbs0rRgMkGmJ6t7EIHxh8m1+SvRfXr3FktIpSc9ynYY5iKx5lMmjlLKIFhnhloqhSl/K5fCuf7/HFTloTqdcUWCZUFsc7Aj0gTT1/Gxaq/k0QwOkWoshsK8+A2IXj3dU8uU4xNF6RI0u9CkB8srCWuCgn5jGb2/uRz6yRkmNJmllvDB1BFWcytY42Un6Cg5nq/Dv9qEgdzP0IDNKwF1n/n5qsZUJAhHasVmw5RS/GES9W7J5AR/EQ2+qwBJVmjZ1MTX6KLzZ/G7lT+ZP8459Gi/IMC6AuOPZMU7INkWcEVKI3HnNnYQ5HisRwdSa/Y5cpouqp9KPKMs78c+u30JKANprmvPnXNku5xaP3c2UlwphACK9MqFDApDaX3P6AcLx5lR9J8NBIJe1mPFg
 mbpjNGqu
 K7EqzikZ3ZX9BfTq2vICprRiRyold+fBS94zEandXbYjToDPStL79iJOofTgFzdjDFcxVBoluhKqmUhotm1f0cJKiwy3c8dTV01/EQgHeydO8/21G6w1oldGJh93LtvMdAqH958Y1xPyRYJ5XDQ7i4XEQthRb0M0wRyx9xzVTv/ZJBPkYIxa+wkuFI8aWXlRSKbGzEqBSaSwUluFEzXWI09iRR81LsBVRXsJB9K+uy4z4+VnC0BJRIoxiE+o9de+UDbKhQnyECjT4OIqrbulhcUB4eOWcPVocV5Hwq28BPH6QX/GzKqI9oHTrinsP0HWGfT3y/mTOEj8sBvB/2JQ96UdXGpdNMTPiMFhakhH/F4g/4Khx4uVhc4k61udxX0CccyK8vRBk/75WbJJiwM1mb+XkrvKWU9OVrPrb8P91Fmwx3DuJVUzCtFK7QTHot+Cb2CrynXAXxXCul2zoOL2/ILht5Dum7Wh5Qi2D5yMIUPAV4/pGbVLgxcDNwe3lYzko2wOvhE6S2EJYPkM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Chris Down writes:
>- run_vmtests runs with -T expect_sealed when CONFIG_MSEAL_SYSTEM_MAPPINGS=y

Er, the other way around. I meant vm_runtests passes -T expect_sealed _unless_ 
CONFIG_MSEAL_SYSTEM_MAPPINGS=y.

