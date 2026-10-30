Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F95606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=ZVAwe7xZ
Received: by kanga.kvack.org (Postfix)
	id E83096B05C7; Fri, 30 Oct 2026 10:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED936B05C8; Fri, 30 Oct 2026 10:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADC26B05C9; Fri, 30 Oct 2026 10:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA316B05C7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:46:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 903EE1C40BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:46:19 +0000 (UTC)
X-FDA: 85379568078.19.6AAB021
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9D37D2000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:46:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=ZVAwe7xZ;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDfFuK4DV2rycFo6z7Q9L1F34BxLwMu6adMyDScYC/4=;
	b=NA2DaPicrEBdxSHPzaXpDTgLr1Qo2M2aE6nI+AeSSMwN4WgD/uE1Dl3ePIN2bZ0123wjJ+
	Y9X1tckakJDnquqyqkQkLSkFFqwHtrNePE7ySrE9WjK7xmjTUWtxBOaRPPYzMA2ZI1iMn4
	IvXqowxgDcqShlTluYdWeJdD6irhmRQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=ZVAwe7xZ;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371577;
	b=uE9ZOUyX+j9y9EcET04BeJ62zwi+opVowGBXZq7iubU3MujuCSFC1CdY2o+EvRGZofo0bo
	+o4hbVsiqTwJfR66yx09yeyTRzEL18Pk+bqoZRRmVuMH0nJ4+i4/GX4Z7Kqm84qCymLk4+
	rOwoaqsp+zDaVqD0eIxoTk2fINEXE9I=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91c905d7b6bso8396606d6.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371577; x=1793976377; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tDfFuK4DV2rycFo6z7Q9L1F34BxLwMu6adMyDScYC/4=;
        b=ZVAwe7xZKs6gbzenlb75iq+hRMZjJ0qBo4yhn7j6SCSJr/4kAvpb+ElrWy3n4EDcry
         GzcXHWBJX1ZdmpMCNa6b/L6B/ZUP/NYC3Ns8PZF0E6tB+YsjPDD8fV0wPNEX85TDC/jN
         80gK37mZphuaExcqfUuZ7z2pHrLLGhAnSV571aeSwLWmu6bWiiLSM3czJ3BpDQccL6TX
         3tnS202weSyeK2caoJ/xSRQEcblkTWBoJ43VjzZ9zwSNxp+fL5EqXkU2dB+Wo5qgvdP3
         KJqk5svp+LxX5y8oraGqKNXZKDdF1NyEUU8A1J8kq3j45hJe7jO3O3mGq/h4Yxo8eBvG
         TgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371577; x=1793976377;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tDfFuK4DV2rycFo6z7Q9L1F34BxLwMu6adMyDScYC/4=;
        b=PYCFn2Z1kEEuPxZcl0o7uAmauLMVWadxWF06/GsqUi3WiNlbRFYAK6u1TZxI5x+AJo
         qPvfeuI6N4zYmnS0kbbJQDPlrHR5NGZ0S0YY1F4Qyje+raXh92Q8pbVQdGYXhr6ktIKg
         O+oL76MpLFnmUKEfa53domOPwZxIbEX9tYVW1bJBzrpM3sCt9mONB/LcKJx6uAcoK5U0
         oRUi2CuhXVT38oOnwlSPJ2IpjtVWI4XrwVADrsYCydu3NByJ3lyzrlMDpM4RNnSq3C1c
         2EP71qo0OCqWk+GQeVMeM4ZvHmih2zqUHbFpuKxyjzKIunS9SRqsqoPGsRxTxIPdVkkm
         oKzA==
X-Gm-Message-State: AFq9FYIPSaBZFaws70E7dYwIxpoUequEmx6Er+nouaDU2G7zpyNfsYk1
	zCNsmAexTbM2eZkzn6NQpjlh2jsc+Q4y+Vo9CueQHQ+jpmr1Pxz/DNqE7YMChM3YQ/sAYy0mFXG
	av2VQwiE=
X-Gm-Gg: AYBFou2NJ1OwTkVJVmHCGiYZb9Moh7kqpWC0C2hxKrr/TF8Z++/N0hZjGc0a+px3K9a
	vQchjLG5rvA+wfPemQb90g8drqdq5CyjimYDlLBiZWGPFGD/OZVs493b6wnFR6Z1lW80mfwFVi+
	qOaXKEb9+yNaB06wBCanTbaYUwaIYb6AOOTjDxYIdHdfmYu8mB+y3zuzNb65JbPfG4lz+2/FiSn
	6BMHpEbB/A7OlIWRpsd2P0HBGIyUCfsWotH+szGAq8zWwTI7iLYAfQafmYd5WaROMz3maFsyi8v
	XdSxJaRLrwGRQo9CI8X7bHQ8vu/GR7qPW/a+F9HYmVdV7XozC9LREf2bZUtwdZmHsoIjmLOJL3U
	7lbnvMSF/SP2c6nx8Py0yQ9izEyiwcFcQnhtpMK/XWumnBv8O3CKumuExOOm4QX9MimSaLg9yFu
	I9qgjJZyCwVf2nn0Qn/ew5pHluKjZNVyBACDi2MgYHsJKTfG+xufqZoBf971FaKyCxNov1xD7cR
	caXgdbmcfD88EbkDXqrvsOY6zox5siPZt4y35nYEk9SsRqEW2rahBOq8SSiTyG2dCMbedtJr6B+
	6W44ryiR0lEcpKNw3sT93f4kuJS/YT1EkOSz6JzPh40r
X-Received: by 2002:a05:620a:84c4:b0:93f:1ed3:a9d7 with SMTP id af79cd13be357-94421719099mr396848385a.27.1793371576775;
        Fri, 30 Oct 2026 07:46:16 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9442581b2ddsm158514785a.11.2026.10.30.07.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:46:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:46:05 +0000
Subject: [PATCH 2/2] binfmt_elf: don't leave the alignment probe mapped
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-binfmt-elf-trim-v1-2-dbd8683bccf9@toxicpanda.com>
References: <20261030-b4-binfmt-elf-trim-v1-0-dbd8683bccf9@toxicpanda.com>
In-Reply-To: <20261030-b4-binfmt-elf-trim-v1-0-dbd8683bccf9@toxicpanda.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371570; l=1210;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=X/ASOFjcZWFCPphxCek+/PZuE8QILdbqMeZPQM3mC6s=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QIGjAMucuuZ7Y3nPwVmOqkc31/+E3a6jL83u12VI2pAeoRBg/AeoxSja/iLAsGBUefnVDd5aaFp
 WOqPTZ57jWg4=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: 9D37D2000C
X-Stat-Signature: dgm83b7u9y9e4kjcinxnto4stbt4oy3n
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371577-55737
X-HE-Meta: U2FsdGVkX182sA1AKcxcZ98YQMc4a3yyvEPKnR2tIQVyo86wKfNgbOFw/F4X/+G96cZ0/SucLbujnaIvh6WB4yMyj4GhHlt/1fyqP4hhVA5rXoGkTu2fYMTm3IwSAhczTIDgdz2BDdblJCrFLWo50y5iCQlv0beYG1NA5sZa2BCeNbvl2FxdUcUjAoKaQMwJ3w9AzDg4kaTXk18WxbX0z3r+rmob0nY5nTa8rj7cvoE/xnu3OVmpSzOKdVNkIl7C9aZnmiTw+yy/dOwsip9QSVw9R/72FRpiSe3pd3Cg7cvD65LbsiBuqv2EBe5ckHw/VKhkqNfnZfJeY7jGQIn0BjT57u+1IpCWqGIjiv6DrwNTLKssJO/fMnz91knIGnbXY3VIAdEa5JCv3qb/bABFDF9cYogedkl1eklqCElseBexc1GUj6hR7pY6BGe6Fq+C1AXyXC6CfSvkp03PYrAXOaHClq57zUunNIe4QgZCNf2HOn2iS5M62bhflq1D19GvlSnpIOyOLNDoM0mbT7JZSyhHgHASa+jkRbSNv6w7ClA2xi2uKW1O6udLWRIF2jk7Ebw1aihVmkz0Vh9GBSr7MsLwc9nlMfKdURbRH36VGgI9NRIyqGd7Si2J3mojreGWIxv2Cv7LzBS0c0uklwHPXm0YwpNfvM26CvCjKCcN6gpsTTdJJVILQQ1YFVlrsqdG7fyf6ScLaYpiyQs9OfzE4fa5ppK2DmWUXSsnUx01gb2m1pCmkcDJFqQUZVpI1oF+nfqiZ1opZsjOXRVDphsSfgswgS+Prp1ObAHLX3HUUC0iwIF86/+upniPaiVdBU56s2634qDjwRW8dYBA23yiInIVe6s/7JOUqlmIYvPglk2Xw3Rt8x/1er7rs2ZHyX2uB2nZ6KgnN/ThdxPaMtLGBvKS2lWWueoQXU96dPMjsblh8lwX9QI+nKgcoU4f+qoP6+wxI49+l4csPq2Svdq
 DXwPHBI3
 P+A30/pqP8SdvDTZhzksNdohsJOqEK1zuT7QWfaQoZHIQHDqpb8gkdutFdWvNTRjeDqab1VcanzAbB6hyu5bYyJ54rej5sDBoSgSFC319xz3prVldDgj8ncpr8S/Py/mBH6QSR0lz4fW6Ld0qYyabt3AmFSkqhYlllLr96P0CaGFqy9V/YCbz291RW9/9punXhd3wShnqBT+RUt1X5LDop3Cl+484GfsIlju67BMYD+AWQ0qKPJhmhieFyX7vIwLnhGzgCX2Lu4O2EKmZTts/KMxFxh1VgZ4EJXaCH1rf8K8xPenHMMtsoL93ngrd/wSgWAcbvEWX7F0kYHg8ORoxGmQ9Di6wS+wbgOKb1XFo2JcLZpNkyY80PrMFVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A static PIE whose segments ask for more than page alignment can be started
with a stray mapping of its first segment in its address space.

load_elf_binary() maps such an image once to find a large enough address
range and unmaps it again, dropping the result of vm_munmap(). That unmap
can fail, and MAP_FIXED_NOREPLACE only notices what was left behind if the
first segment overlaps it. This was found by reading the code and was not
reproduced.

Fix by failing the exec if the probe can't be unmapped.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/binfmt_elf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bf0d4df16ae1..6df0a6d979fa 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1171,7 +1171,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 							 PTR_ERR((void*)load_bias) : -EINVAL;
 						goto out_free_dentry;
 					}
-					vm_munmap(load_bias, total_size);
+					retval = vm_munmap(load_bias, total_size);
+					if (retval)
+						goto out_free_dentry;
 					/* Adjust alignment as requested. */
 					if (alignment)
 						load_bias &= ~(alignment - 1);

-- 
2.55.0


