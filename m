Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F389CA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544518E0045; Mon,  1 Sep 2025 08:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3548E0013; Mon,  1 Sep 2025 08:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAEC8E0045; Mon,  1 Sep 2025 08:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1501D8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8F43140816
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:49 +0000 (UTC)
X-FDA: 83840615418.09.36B9150
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 047EC1C000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Q3ove7Gh;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729848; a=rsa-sha256;
	cv=none;
	b=76d7NnIAtSODQ4LhtKRgFo8edTQrjh5FO100j96I7NhgA9gs5OItLIjZO2eCu6oKIOv1au
	hjUrd/mnPEyY5bkFb5QJBMNTh/oR4lIOhkExNOFpiy7cj8Pd+++TlNnff3ziwzxhd3gVjg
	o316PgEfEdxVI7W+awOB1Vf1Q2/0UPA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Q3ove7Gh;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TakQ8h85rIAa1grDUxPMVyoALGVgUpKOsAVdRA9oxes=;
	b=KxJqK9qrHlPdZEt9caU/IZ0zfR6tFz7O9YJC7uSuDHmXudzfByA0jd4BDxdwIHTGXg+jF4
	GaNZ98EHPN5jkdODxUZzzCJb+VttxHUvpAsIwON4Bxr21yLYmPBlYwDWaz5TMCpUveZ51y
	vhe822yMhij+TyCBF+/0bJItHWJZQpc=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b00a9989633so364746766b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729846; x=1757334646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TakQ8h85rIAa1grDUxPMVyoALGVgUpKOsAVdRA9oxes=;
        b=Q3ove7GhjuqxiGVN02ENpW3mnKJc394BYVf17a5cLkutT3XNkvtKCpp6jqCxiBrv79
         S7WFPQ2F3crWyGS9YTTQRSAZ89RuZxCjhWw1ikkFePxKmoNKdJncGKrb0bJUfa8nUZSi
         q4Z6EYHbVeJCUq07XnORJnQ5VGwyxmOhxVSBz9eTY5l0QNBWxDkwa8vOh++P4uiFwo/s
         I9VG23v+7jkeNPuHN6v4SUSvuBR0sfsKCYEOOSJ67Cle4R3xEYKIWUICvPsIK0suJc8T
         LIEerKLam2GOOS8nPH2C41xarkNrCzSOw5ttX/f1z6aA8NzElpaP9wCAv7KxpOFXSLEY
         HlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729846; x=1757334646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TakQ8h85rIAa1grDUxPMVyoALGVgUpKOsAVdRA9oxes=;
        b=ombUPZto882cLiD2/EEx3NddfQwOSHumTKGlmec1v0XJ2HSmYUYt+0Ck82sdPwJGjQ
         K1Ofxs3zalHk9iKZPnWXBmKAnN6ZSAUUcyq7d0wBN4S8e8/k62mA9LObu8hR2MDTJgWB
         MQrt4RBdlzX+Cu+IX17XiPlpYnSpK3vpzDlJ99kW7eHLfNzr/2pYGYEGdtEWgyNJ/pMY
         RcV/l9Vp0G3/OzS4vTff07m0FZLBTUVqFWfy7YArNJr9U9MG2dKnP/a260f/aH7TdgEm
         SKSNTOUAkECOEJVb0S59r77Ykyfs92Rj44Hlbp1PVE75PuRsZzcLAzY9/4PFiHvaKNLz
         kL2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAtHSliJatydz2VlEFTN/9PZI3uuOnuPq4+6+mAIKu0Qn+KVwPW9dT70aGd1vp1QODkBhNkdwYiQ==@kvack.org
X-Gm-Message-State: AOJu0YwdU6qimSTr4x+t+HP/zkp+0v/BF0tHyqoMfFBarzwsSsAz29lb
	f9GbI2lh6MP6KQ7Plw7ZUSz+gQLUAoTlA7JK2us8QlTiKK0+f1vy7cO9uPW+WUjjxDA=
X-Gm-Gg: ASbGncvfQfslgx2ok0DFNRqZIVLMxSa1/28xClkei2snAO4veKutA2W0wrg+fM7jYhU
	Z4Db38tVE01eRrHuqFTQkvryNemtVb3+fmuWqwzzXO2DrNHbQFd/qdxvd1pRHMFrY7zGsVQLxhk
	R8vVlTld5bndAV8DSkF73p3w5hNQ2bdTwIdfAJ29w58T9yBMd6t6ZqOffF57tSFT7lciyoA5pjZ
	d8ZRqlv/JmwHNMfkxyoP1J47mCxLrRlE5A0AmW9LfnVeWrgfxaF4I1kTtnaqSykkmjgw8TDsEWP
	Iwr+v/E7I+821bcs4BWhwq6Es0xwz2FFuwAsMunV1QGmg7iXasjiqAVLDqWRMcQcZNh49t+u1q5
	2Cv5QmCk7mqfuwSAxmpWhM6YqKQBfVyu1NvQnNnPvokpuLA1kCIH0LKYN0aUtli2SxoUE7oqH5x
	aVmlbYXvrkrsgrXP+gcdRU4snpeOJikvqn
X-Google-Smtp-Source: AGHT+IEFyUt84N4Cv2kdLXAVUn+1e4FWCkv0k7DfQxCZiqDejVRSf4epoqkxZrOG2Uh7zwz0dBY6jw==
X-Received: by 2002:a17:907:7f1f:b0:afe:94d7:7283 with SMTP id a640c23a62f3a-b01083377eamr695696366b.32.1756729846177;
        Mon, 01 Sep 2025 05:30:46 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:45 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 07/12] parisc: constify mmap_upper_limit() parameter for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:23 +0200
Message-ID: <20250901123028.3383461-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 047EC1C000F
X-Stat-Signature: 698z5wkdc1ubw9pmw5owiq1rf1e91d1k
X-HE-Tag: 1756729847-411561
X-HE-Meta: U2FsdGVkX183i8wRcht8ibtQ3GZUQ9MZRCl4rpsk+hInYI03K84Wi0PB343uw5DmLFWoshk/M27RNMVAgGwuh4CAf2rGC+584JnJWQrwKBvrpWx0mpnxAZYw8WZkcZVZeUJP7yhlz+rz9LuRPRoGxa2wBj3Ay4o031j0kKuQWS8oMfo6wbX20H/f7nL8V2pfItTondOPRQOrJmnc596t78E4El29s5hZjzKT3VSj8U5nmw9hckf6+Yl8CbDzbZIEJ8aJoqgb7EKtbgdxm2iZ7nLU7G4RxhIce2gC1tz6YlD78myIX/at0ZYJC0tl6/LGvudXbIjE8XfyepE3wp3pBpdbDfeeBtseje9lo7z9NKoOBtaAccV0QmMj5ibTRmoVNQ8h7sC9ekKkkeO0V1Pzba17b9YTtLBk06tOCNwrhxzxHRTEAulvEf9kMjjNk/VWlalfMPrVeeKDDksV8Q09CPDRqPTi8RHuX+qWnzl2ZUjMdwdSLPcPVNfZNHUn2RLfydz6yZtrqWtZNw2Iw3LDW/UW4TNbJZMGb1WwD+OKWpYbb56995uYm0J9s+n/wwE1v0WA2kLhtw+d4FFUaQCLhHxHU13aIR03KClZ060/RDBRpC/g9f983godg5jC0ImOiLW7fNMeaes9TzfB7KVV/CiG7qrmzP7PNF62an5CRGHv9hVq0nUDspXfCFKvynImpi183mshBTwwTjNqFGLv52BPZNw8RkmLYfUW72LSOdnsKsxaYBz1o5Si7AwIm6oj/gBBdluGbHv0nAya9QtZhD3YAHnqtgM2hsob5itbwdz2S9a3vNXvV81COPDrh/X4aw7U6LQaorGaNlFINO6OmrIgjk5rmJiL/02MfwSL5g4l2hC1KN7pgAGtqchm67WvejyNmJSWERRxygmIGPPjHC/IOF90rzgLrJb0BNL7ZDgaMpKuyIzIXi4MwpxdL0nVCG5Lx57QglJBQ5Q+mWs
 Za1fZ8G8
 OhP/KEBBpGpN1lwlxJ/2/lx7YXqn79bHk9n4Vgyu1zUsoIDZRBzNF/u6Uur8slYZosX8DWyGufzo3U9Ib2W1p2LqkxoC0m10MLaikJc+sfiWjha5g8Zpr7O6oFQ1Z/6iqkBVPuifB9yEp7m63P6iCC7G7nkmhde19aHry1yylcW+u+QebkoJNrt4dXFpfkpPEryu+4U4K41DV50jjShEHfn7eqSIUT0eLybMQb7bcKRHlguiizdQ58lthvObGu21OWSYRpxQ86BY9moSmZnthwsFQAmVo/+QtZ8D8+M92oIGJ8T88A5mbSLpq2s+TiGYFkkEw2eVEq0cPa1YUoqsDVhjARYUEGScgW1lxN4LKGi+7CpedWaVSJWr8MGs4IUpseaHQ6Sr8aoqFmVqOSI+1SGbl6dY8Bbm+1TcRVQhc6dcLu35jy/lOw3S2unKXqFXvDqdxElBfTFH1XMy2XUpUWjG1mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This piece is necessary to make the `rlim_stack` parameter to
mmap_base() const.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/parisc/include/asm/processor.h | 2 +-
 arch/parisc/kernel/sys_parisc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 4c14bde39aac..dd0b5e199559 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -48,7 +48,7 @@
 #ifndef __ASSEMBLER__
 
 struct rlimit;
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index f852fe274abe..c2bbaef7e6b7 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsigned long stack_max)
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *const rlim_stack)
 {
 	unsigned long stack_base;
 
-- 
2.47.2


