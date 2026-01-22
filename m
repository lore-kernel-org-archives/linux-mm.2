Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FDFC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 05:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB606B00E1; Thu, 22 Jan 2026 00:55:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78976B00E3; Thu, 22 Jan 2026 00:55:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5066B00E4; Thu, 22 Jan 2026 00:55:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C57F36B00E1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:55:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36EE286864
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:55:00 +0000 (UTC)
X-FDA: 84358536360.26.7F8314D
Received: from mail-dy1-f196.google.com (mail-dy1-f196.google.com [74.125.82.196])
	by imf14.hostedemail.com (Postfix) with ESMTP id 65A63100008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:54:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OIMD1OPS;
	spf=pass (imf14.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769061298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=db5L71lFil1nMt4m3zHfhoBZD7zBth9lGqCdL+1iytU=;
	b=JiaifkDLwM6XCtH8GTN1Ul9jUJFE6dSGH3eKwkWh0TPzKzpLswpUdMwAsejSm/ykMKrrPw
	YFWPmeeOLxXKKJ4njj/91Oyqs90O7JHIYa4cNM0uIlZ4+HGPEV6EGbUJpSRjfOC65jgAPS
	8TIlWz+aAnW93wZP+SlSibLc/qBbfQw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OIMD1OPS;
	spf=pass (imf14.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769061298; a=rsa-sha256;
	cv=none;
	b=djAIR+wiuPQLrwb8iybVPRdcyBIVG0k7UzBVgr74/SsAziM3YHdNQePMfuanwiEouTePqf
	VefJQjsSm+cc/czpTUX6dWsKdsPW6XZWlUKqDWS9sKhuA+zQbxXKckhSBAdPQ8spzYPYRO
	KYOHlOjtWU9kFhNyoc3NQuXTvkpS2nU=
Received: by mail-dy1-f196.google.com with SMTP id 5a478bee46e88-2ae287a8444so328894eec.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769061297; x=1769666097; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=db5L71lFil1nMt4m3zHfhoBZD7zBth9lGqCdL+1iytU=;
        b=OIMD1OPSYvxjyRVvMQMjYrqRVV511R+xzds1ytcC1JaZ7jqUVR7XbLQYJ7Qpkt3W6Y
         SsVbjOrftBLOqao4wz3wVBraxg1j/4CTKRM+Dj6AbNupHZyKXV+EehoqQGxGQJ6xl3Bf
         lN4h8kXeMEgSVV/0THyo/W3UiQcEjj9QTVv72k0WsJcDQnKB9Li2ehTkO8Stg/tgygmQ
         l/YFyxX0Xe34F2MmXILW39jQMqBx9hCRxUYFnNK39Kzv71aleopabCPTDheZS4LhgP1V
         R1TxTwH5nuFn3CIPuwT//y6QsDxp66P94F/EZK68nV1eB9BCBE0KghVqe0ZTshIrTdFx
         bc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769061297; x=1769666097;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=db5L71lFil1nMt4m3zHfhoBZD7zBth9lGqCdL+1iytU=;
        b=nljqyQtqua/j/01j9GuIHellmM/t92UQ9XwHrhvcU0wn8uHsVTzQaOFJUVHQlDA3TW
         s+g4vAeg8yVfQ8KfUY/jNVQDM704FO/SmS4VSmkslHgGBit3UqDC6NuoamiMoaP67akW
         sB2onWtIuWpSKMpeV5nq/bELMdHFS8DqX4F4DzgE4aC7Ew+/gYZ5gMRg7D6DYsjXfmFz
         6cRm220AKPCmfcVXfFDCRkF6nONfylbRn/9vWJJTlggQvhtjmukAey6AnFR4KhsRBazQ
         oM3ZidQjC5vm6awee5gd/ixZKoXzhifVVOAYx/Jt4pxUHriXtgqYGh0h4YVXLg3DQsos
         2+qA==
X-Forwarded-Encrypted: i=1; AJvYcCXbjwvdqFdTAWJLY+tUypSBOh9uriEjCD2IEJ0OBj98/N+M2hyB4YAXxin1nY43zNf50b1/rnKFag==@kvack.org
X-Gm-Message-State: AOJu0Yzn+joDFEthyn37h44UenbZsxV44wq5QM3LL8FEa/VHfNDtTibY
	wIyyHnJvPnbs/D0lpdoMcsYOzwvfF4IGAVLbmxNcA2nmvqhZECxA6PK1
X-Gm-Gg: AZuq6aLTVXOHrQuwDVgzGIiQ4Kuqcad449arLMcVFIT5+3TYRewEGhD1RAlm5xjrgBQ
	pEUq3C7TVJr4MiOEn7KSCjctCNE5luxu0EC92C8uOna1a8N4KHBA3PvuJhggCPsvgMmkNzbzF3V
	XWkT8MPFcgvao6+k90RADTgYCExg77gGDK1GMb/ksRjlLvhPNc4EfpM0FhEe6RCurVXOR8s59RP
	e4HOq4Vk0S+Jp4mwziyVx5PvH8iNcCkOpD97EEohO1oiNF+VajbfNQ1kC6LBo0Hx3R8PSpCaeC1
	/jZ7k6Fwz75Y+Pqc1f/yvehEKWtWaFlXOouMLJp5DZIx2A8u5fHdPDQTWioHGjhIlCAn5lKDnSs
	7U0FP4iAxxc5WwS5wxgtGto0+UvBBEIjKBjfCb+/dP+dQLwqvnSII+6QV0jvANwce2f8eIuB4ZS
	PFNpJel602iFvYgKPqEphd2MrOetU+MIlYPzTIb0ltEj03rvQ=
X-Received: by 2002:a05:7300:d70b:b0:2b7:19a1:3bae with SMTP id 5a478bee46e88-2b724801cd0mr1034781eec.18.1769061296697;
        Wed, 21 Jan 2026 21:54:56 -0800 (PST)
Received: from 9fdcf7ea0ed5.localdomain ([142.171.172.108])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7047b099bsm8154623eec.31.2026.01.21.21.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 21:54:56 -0800 (PST)
From: Wentong Tian <tianwentong2000@gmail.com>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com
Cc: tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wentong Tian <tianwentong2000@gmail.com>
Subject: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
Date: Thu, 22 Jan 2026 13:54:35 +0800
Message-Id: <20260122055435.95911-1-tianwentong2000@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65A63100008
X-Stat-Signature: jb8f45rep6jt89fehdhe446hpo6sjrph
X-Rspam-User: 
X-HE-Tag: 1769061298-134351
X-HE-Meta: U2FsdGVkX19quwbpTs/ZuhL2//DPDQj6d+J9+x5n9SuvdqLNb6uJiX03ROiAVEgYB4BwPRTvMtJCezA7VpHoR/f0xMk9N0E7/vDMiOfXhbrAaDtHYAp+NptvgkaeTSz6qF057NfZxhXvmcU6RL+0mcN+vstbNa2z2HPiRJeTUq6hL/Cb2okOcXB5DPBxVOkb9guAEoCg7rLIdUJ5fmAnvPTff9LMoaG2nW9hNvC6kSfHdYm2a8cZ4CH5ILWkw4kRrudYfI5w21uSyqCJy5YeGjfQS/+CwJQ6ZVjl1EUJV8tJlrqWYxD9GLoHx7ZxawzOhwkXku9O5Xq8CKSrdQmdQjArd23G9jkVYQ6kXpLFPKm0NAWTJmgIVn7sYKgeO66OAIkvYrpLi6sLm1Rk4BCYwY03jUrBiITUozzYoa86YqSKJ7c+ZWPeU3ly5LDLAN4pVqkKP/glphonsffcp1bDmCxNZiri3L78RK+1DEybsi8SqRC8XOU6v+umtwBG3TaDQJ6qY8x1DFhsjTgaOyv/uoFIO/fbVQ13gOM+JL4ULWgjMSDjJFnjhJCw/7NaoS1zlbPa7WSo64wl2Wg/nNuPgc+kCpETa9MgUBDpaAzvixTlvtdcrrsKK44KX4YOiPC/e7OEq6e4XlJ79edaPd22P2jWq+eGCyBkIMaj30Ysui0iaIXzBPHT7GcPFT1Sow2j7cyxF7k0PwXNnaqN4DYAZ/5vh+VrmNcMT8FzsC5aMOQRNFKz0ciWw1a2/SiEEXG/WMEYHO80p38Yq8skPruXiFLWQqhwG6EIKSoYOrnELfWQOehQfXUJWPOEAEUgtxoPuQH7ovQC6q/kWAM0wbAYMUOpFoZnDtIi8VhyfmFlyHeYtyfsnkrEmTKDpr9Ski91frjV65rjmyGYPGsqrxhrYdMdN7SGUfEdyZV6lMWh8y51N8kKRknSeXiZ6Dz2h4cQGb54fSzIBv3WqrD8xTC
 U3u5Gra6
 5yl8ssecD64aQLGb1N76KQ/ilbaBpKrR7QlG/GA7dqs6BvNOEvp7TtScUTNZ6e9xhXPYXw9b7l/MGEGTLAIFfYRtjlE94sl2YHNdsWsXcWQVFvZosYHoYc6YQYeYK5tOmIGo8acS82MLB8TtkXq51f96iINaZxlLfnZAuyWiJWdqDti2jB/2NHYSUugMMGUiQf+PHh8pwFGza9SwHiHyMs+SREUbLHg3icrllF08aPGEdTLvCzC3uhFeLcnJruOFmpmutX6qSsFuviT0tjeAsWcV4My8gObQGkSI0V2pDHLh5h4+HVF9dEfxU+pCYFDkG5f44jsgPF55KtYZbIKHIMQGLeiMj2lNkrF8we8IVi10s2YX1mfikUgu3oDXbU5XXYbwbsvdUJM583USXF2oeoANx4mvbTXtKDNd0NX28lLZFrlHiuIPJ/OkhEVFnA+6hOCjJdlJf5w4JuOQGFkOpxCTIkzg4gdW0eRcR23IgjpCWKcHQmKgHURV4Wet7VpmtuWcT3sPFHyY/4A6fhEokq6ph5oguJsehOqz9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm_flags_t type is the dedicated type for virtual memory flags.
Architecture and driver code should use this type instead of assuming
vm_flags is an unsigned long, as the underlying type may change in the
future.

This follows the cleanup in commit d75fa3c94750 ("mm: update
architecture and driver code to use vm_flags_t") by converting the
remaining vm_prot_bits usage in SGX code.

No functional change intended.

Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index cf149b9f4916..814edcde225d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
 						       unsigned long addr,
 						       vm_flags_t vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
+	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *entry;
 
 	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
-- 
2.34.1


