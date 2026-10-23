Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A7A606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cJ5zMrr5
Received: by kanga.kvack.org (Postfix)
	id 2C80B6B0B98; Fri, 23 Oct 2026 12:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278D46B0B9A; Fri, 23 Oct 2026 12:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18EE06B0B9B; Fri, 23 Oct 2026 12:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0F8A6B0B98
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:02:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60774C015E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:02:49 +0000 (UTC)
X-FDA: 85354359258.16.1B3AEC7
Received: from mail-pz2-f6.google.com (mail-pz2-f6.google.com [74.125.228.6])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FBB218000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:02:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cJ5zMrr5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792771367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bA0Hsp5XXumXBy4rVBwW8fxcNqmGHi/YDDxKz56CdE0=;
	b=0G73gxOPtXg0ai6OZRaAztyvvwoDoGZmEeFc/BdqSpKmdXSdutJrPF/+DdYAf1z1o6YJSm
	vn9u8IgIld3iX82jOjqizg5fsP29VxEWw0rcrUtX6bBMFgJbUFjg17YRzdG26rioob5t8p
	q6cPJO6xvutX0I3/dTX9+APkALOm4/U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cJ5zMrr5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792771367;
	b=JDTmvro64Vd9rJ9lZO5LiblS7oL1VhcNVBY8bKcWwtIEG8XpOfT3AMNve9gc+yP3GyFM4M
	x6jttUcaBDC1Qhb/Dm5O4s0YURQfagJW4hOmxqyb60gtjzXVRxl2zo7dstZL8RZnk7zoql
	8eZasopUKzVGxP1KMy2qJ3BOnEEBAuk=
Received: by mail-pz2-f6.google.com with SMTP id 41be03b00d2f7-cc75f2924abso612608a12.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792771366; x=1793376166; darn=kvack.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bA0Hsp5XXumXBy4rVBwW8fxcNqmGHi/YDDxKz56CdE0=;
        b=cJ5zMrr5aEnmX1mxYTBb2eu5wTjiqPHLKVVtF/EyGhUtBIUcomUrMj+yfwcvrel4vl
         BuhJyJRg6zxGM14JnYacGgpKqAM/VHnvoZ77ZirRcMmjGy+ame3oWuZymWMHerA5Jm2L
         OB3sZw6sEh26IpwHAJ5rXwitRidZkY7aoRBr5adLu3hPsQgJRrxebRrCYABvHVStxb+/
         xw1r3qRnmWcqGXR9yWUm0rNSPdz6uFbi79+Qs0tXyllD4mimLJzsM0z7YM0mBVsUSJc2
         HuvyMnmmc2P39g7ZIdSGKf+pSArRBUbsHv+2epww8IKtF7PWSFVkNaNK/1odEN406IJ+
         Q51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792771366; x=1793376166;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bA0Hsp5XXumXBy4rVBwW8fxcNqmGHi/YDDxKz56CdE0=;
        b=o0pvq86jaO/Az7dp+D6+OB0CFO5EYYAKRG2zN+2lw71eCyZaLTmdHDRMya4e4qytoL
         znUFKYeDod7YFPSQzYexVUspAlwnRmX97RRa6ZpTm/ElulD/47afRu2aSRhsJVS4i8ba
         cHhwGPYKBR6lQm99LAK9bvKZhEkxvLhkdBH7V7DKWLj+XvHEB087x7j6D1Cu5DrlKxPu
         RQMtIzWI/CsWm8WT7kmgltDxNJVfrNdLUdlm2RugNvNv7xzvaBn0TCCKe5TvIeMPC/bt
         QB2aZRtjE09v/eYnuUzIm8Q2rpyGTCCRXC9qhbV2imo+ZuDpACHW1tNpk9a7aMn0I9RL
         ixvw==
X-Forwarded-Encrypted: i=1; AKwUvBwM+tmFT4sLWKXgtitRz5faOLOoZRJ+6fe9kf+i2DhK5RSwj80RR8RBRkMtCqViOUY+mJWVJgKVDg==@kvack.org
X-Gm-Message-State: AFq9FYKHR7BQmH+6sIlfNBg/mWK8kT8EpTSzjSIKmRVFa3RvRHM6QQ5Z
	jvyZFsJ/hvoH9rq87bKqZhlPlRfcjyjMGTrrqBq/+cd/lGPPe6UhQ/Pq
X-Gm-Gg: AYBFou2szgutZ1HA0d2xtFkU1aARUgNBa+tFjJ3UnbDZZrx9NwP0nunmaStm6ZcM370
	qiuHxAi4d3hzfzOCp5bObHnnhkzBnGxuszmtvliw8vYSe4fPX47v+1K01Ishrd/a/pwinKw16lS
	EStFBzv7W0UEkWJYMA9+V7Q2UyalfaqTmcdPguSRBGYcnKCIwSH0kT/dkoqRNj8aKRGlj8j19+G
	91PW7nOh61SbjWBgPAjNItWKvQlwVrVQJdGIG9jaCuUiW7PGDu1xqLnlvXHLgvRhwGfwhiYWpuP
	L+/uRYS0YR6thc9/4nDOoYbAQFLhn0y1tBMPdtF2xH0HFBy6ipjCZYWAFmwwB9XY6upUK18BGr1
	2KHRS+JGtglpI/fUik259/U82IZcT/SYU6182VmGkBFzd37tQ5IGSrRholAZQv0K7D1U049ktVr
	cBcOvpH95/nFbVQtWEkVuApOBE2tNX1aJD4DWcOoeQKltLMhmK+dawwUPZIGC+YXyKMtXp4Z0UR
	xO/S/hNUaXgqblZQBUiTvBUQJSjjMBg6gtj0bgiTj7Nl9q6zS8hbr0u2BY1R47IlTUvRhHbw0mJ
	pQoTTDSrKAVhBJRoAh8IBWVonGH11UZDd7wbbsy2JEtbutKVenUm/Q==
X-Received: by 2002:a05:6a00:4c94:b0:89d:faf6:c69d with SMTP id d2e1a72fcca58-8a2c66893d8mr2481398b3a.58.1792771366283;
        Fri, 23 Oct 2026 09:02:46 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a336e586f0sm165409b3a.7.2026.10.23.09.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 09:02:46 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
    damon@lists.linux.dev,
    linux-mm@kvack.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/core: reset watermark wait state on each iteration
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 24 Oct 2026 00:01:31 +0800
Message-ID: <179277129124.2.16132047926074873101.damon-empty-schemes@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8FBB218000B
X-Stat-Signature: 99uru8m7u5pctue9dfgzumfe69eus8c8
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792771367-626114
X-HE-Meta: U2FsdGVkX19PcZ1AcjuzUJvvwvVeKeq03zCJyM0/UOOKEbI/PAiXHXoyiQK2bwh0VRn8pQ4jHJIvBFdXXIswtA/vkwqUalqNxF1XZ+m4qMc9Qkzd6LwuetoTfxh1IfV8obdbl5RQ8yXZ26aQbFBWzQVUbtGaEtTw5L5c0pw5/LKJux815bz4JabgfX93E7/IktMD7i5rDj2XgEiZnFMwAH9JuHmQHJYz0cuSpB5wMkurbtHQIegFBHWMUvLBskff97cNaTuDBox5sHNBOleskWbF4U4KEt8Oomd128dGZi83vxIeJTuER5n1X0hkqS8E8x08krqmDaaI+/qg0jIoO0GqGGQl+q7uRPKIvpBRBG9oPva31TcZQbXfXkK0uymPbVHvYRkzCTmqEYthYXjtrzGPYIYLvyp5ZhZ0RXvcHgsIMp1g5t3kG70QNjpMC3Pbt0APeMx8RA53CxGDTwa1GY5ryv+tmtYd05Q0qhXQ50LzoiKeH/nwy6I3TSFW6P1dPuxTrqVpfe/eYWyROfDXwVp/u+e5jZgquzj5V50vPHkroMpKdPH/aiLocB8GDrhrtfOPufoNRScGRnUG63TJM5AhZETevsOHpu+topvOX1Sop4D8HDfDoAcQqwBNcPEMLcpk95y09h7tOhQ8skDQpuPR66NWlnRmbOmNWFC1G8rOxlPtegKhbLoEa3OflrD5efTh5FnEZf9uhbsUa3T+3FfaWTpPbcp4lpSVBB6xpfwPoeyuF+qADrItDT7+cbSwfpUKwbSEusZZ5Glu6i0I+PMFdb2kQXPMriuaBO3K8Hlov8gzf1XUogXzOxL0CM+UjTdV7vwouIMSqVzJobrrHcKfNfEsJ//9PTEvAM+7uLRXl1KasnMxo/isfabTc0m73Khy1A0P/OKhBy/ROAvEmaQ9HH6+2ndJ4NvaBPMbmxU4TjZWqZXDIj43wY8TKfkDjSE2/6ge3r5MlSB6UJe
 GFNAXIC0
 1uF+/731n7W91yA1Mpe3HRfjr0doQpwpvqUNtivexZsmgTzNr+ZBy//tk6kGD9YkxT2fmU8xVO0hTyboFPd6kbdN77JKv/Ex9tyJ99YkbfyN/g45Mgo1iQCSkHMKnH2GFtU41w90soVtZn2z254hrBd0i0hWHteqONdWZnrw9Q/8slt2LIgidQuC7EYgQiFSrEzzA56TwidS/mQH8h1Krg2KjLth9gQp+IeOqUsSJbLotGn7FBfFDNUpxd1amqXLbcDc49vVgupZkp2PimUkooOgvWQtN17GPJr8KNp4qcAUntjYXYo2SmWjT2V1e4Tm6IRh9AbnT5JXS0IWyEO5dYrbrVjJ8nOyU393aBhzsZx9idBspb/ziNgOLcCCkItEoUGZYYoEVf8KYxVTufXeS+LTyiEszrKsk6E1GkWmP7XzbV1/RR22ipvkYhv1LlsKPLM7vqI0f+5W6Btg/wW3oow8IQzxkNXu6BbN5XoUNw+h2lJrqypugLWHYNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Found while reviewing the DAMON source code that if an online commit 
removes all schemes while kdamond is waiting for watermark activation,
the scheme loop becomes empty but min_wait_time keeps the previous 
positive value.  kdamond then keeps sleeping instead of resuming 
monitoring without schemes.

Initialize min_wait_time and init_wait_time on each loop iteration so
the wait is calculated from the current schemes and an empty scheme
list resumes monitoring.

Fixes: 6e74d2bf5a26 ("mm/damon/core: add a new callback for watermarks checks")
Assisted-by: LLM
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
An x86-64 KVM test using free-memory watermarks reproduced the stall
with nr_schemes=0 followed by commit.  The same test resumed monitoring
with this fix.  DAMON KUnit and selftests all passed.

 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index eb1fcdabc007..f61ff763d4de 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3976,10 +3976,11 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 {
 	struct damos *s;
 	unsigned long wait_time;
-	unsigned long min_wait_time = 0;
-	bool init_wait_time = false;
 
 	while (!kdamond_need_stop(ctx)) {
+		unsigned long min_wait_time = 0;
+		bool init_wait_time = false;
+
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
 			if (!init_wait_time || wait_time < min_wait_time) {

