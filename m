Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABA1CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 18:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF998E0095; Mon, 11 Aug 2025 14:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7858E0093; Mon, 11 Aug 2025 14:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8788E0095; Mon, 11 Aug 2025 14:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC90C8E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:25:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DD5CC0278
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:25:12 +0000 (UTC)
X-FDA: 83765303664.22.11C446A
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5E9E140002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:25:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DaX9HgB2;
	spf=pass (imf23.hostedemail.com: domain of wjl.linux@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=wjl.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754936710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GFiR90ByEmrbZSIU4oPPtikQuOT0OadaiRvQ1pEaI/0=;
	b=gXZb+A4qpGvSPci/3H0MmjTtxLpqfZjo3vNurvTDbz4WJJMZAJoibbBqD620Eaw/sU3ads
	oIQvE58ee7pUCYXCOBjd6uygP1KnPcXHquI5AwFEFcMqovfL0XnNap2zC10SyKJKnl2yiT
	FI5NoKr23sE0SfFK+raM0COZ0mKa9wo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DaX9HgB2;
	spf=pass (imf23.hostedemail.com: domain of wjl.linux@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=wjl.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754936710; a=rsa-sha256;
	cv=none;
	b=IkvGA1P2lNtxTjrjNGQ0zeTVIH/2N+5rpbBztd+OaRzwrHU4nMmbENgh4eCmtkiUFWnA50
	SeboiMc1YERqICHjcRuNehBAkKN8xEoE9LKRzxPT+BB4xKin6i+8If5QM9VCKOZmyonXFO
	QFC5jKR+ybpfpu79wgDRkyUEjwh1IFc=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-76bc5e68e26so4348200b3a.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754936709; x=1755541509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GFiR90ByEmrbZSIU4oPPtikQuOT0OadaiRvQ1pEaI/0=;
        b=DaX9HgB2+rJY2N4wPK81kW08rz11WgDn81gXi/IBtRS4c/+pOvahO1yaG3QyzfiXbL
         I0TIctfaky3TPE+B6jLzh5WWT+EKTARi/cbe/zca25aImVUB5ZMh2jGHdI5HSWdB+IHt
         NDP9M6J1JahFB/o8SZGFWQOlOTYlMbg5HusWoTNMLeQd3/QdxbP0abazR/5CpxFJhLaS
         DML+cUTQTwwKA+VHv0BUtaje3fX+hBXVK/eftw6JdwxsE0qu5mPXAfDwE/32DXZj0K8T
         oQKQ1HxOUotz48nWNK7lMmgLaro4iWEUUAbVnlqSrk8KCVP+wo919WZVcVtBA3cqH4+N
         byvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754936709; x=1755541509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GFiR90ByEmrbZSIU4oPPtikQuOT0OadaiRvQ1pEaI/0=;
        b=hUymE91bn4iZa4XLUNfSPBx2z97psblOeg5egopziEZUX1dW00Ek4FMtUYUDWplFKe
         xoyQeXIBKHybtD/EItoM5NbJKYa6i4Uv9RsBiB6q/l33f80kS/oXQjmfoF/9YUnjg4d5
         BR0vZ8Y6CqawQvWFXzS/XvCvv7NFTX4zhqnK9KHhti5D790d8YHT84JcMhhBknPJF6WV
         AsWSIsO0Ql9CTsTNMe+Fnh06+tkBJTVKaM7OwlpJ6ie1Vb5yBcBdvE0+zjILS+13J1TM
         tc4P0DqYJeZPO3z8H+lo1F/bk6zEgMoAOjBIaTLiS3BDinH3SHYsQzeuc/Au5061C5ng
         b45g==
X-Forwarded-Encrypted: i=1; AJvYcCVCno6n4fj1jkWnXB3ti4527XV9NFyBJOilITHVmJgigdcG1lub5yG07aaHlZF8qInQw69DNRap+A==@kvack.org
X-Gm-Message-State: AOJu0YxjLAqgNk/OMXQSi+8070o9VVvArIYAD9Gnya5NjHKs9qNpwOmy
	ssll82jFTwAgEnPFMU4IN+/qkZs81LDFFTRG5BBcslMaBKGTAJ27Zd8e2VvDXjzdiR55hQ==
X-Gm-Gg: ASbGncuNLQZam+NxtypaF/Zh64B3z/EYSFZX+N6zcKIja7rGidQhosYoz44gTNGJn3s
	Vnns4zuTYHPSJpPfku0+Obfgem9mWcOhsb7bw76sDFmSSrn+n58n0RM7v3o11HN9HR8YY3XCzZB
	ijzmy4Ki7usosmze95bz1hLaFyIu9x0rmzGIEyN8Jiq4ci50gW6S8kH54W6dBTg/FVGohIdRFDB
	eCQVRj8CHilT9u7mPu3RU0kEUZkhYU+BvDwLRm42+qqK24WWfEHHrPgnPZfkmkRnlifVUm3QGwC
	/OIy+lTfWJe6C9AKTmRO96bvWbZcRbnbkaQ8faLHR5bPsoAQQUXhhkIshDqmczdTMFr2PVnmnTj
	BG/57acMkA5e8i/wQzA0rUdoGaBXPVHji
X-Google-Smtp-Source: AGHT+IGXJ6A+jBw2s9ZXQYHpLI2Ze6FA2tDiIc8Rtctqegz0VHdY8uYfOogfh0O8oZki2NTtbzW9CA==
X-Received: by 2002:a05:6a00:1388:b0:74c:3547:7f0c with SMTP id d2e1a72fcca58-76e0de2ddf8mr950598b3a.3.1754936709451;
        Mon, 11 Aug 2025 11:25:09 -0700 (PDT)
Received: from archlinux ([2406:da18:c0d:d265:8107:1fcd:5d57:ff7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c020a4a1dsm20101039b3a.13.2025.08.11.11.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:25:08 -0700 (PDT)
From: Jialin Wang <wjl.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jialin Wang <wjl.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] mm/vmscan: remove redundant folio_test_swapbacked()
Date: Tue, 12 Aug 2025 02:25:00 +0800
Message-ID: <20250811182500.42670-1-wjl.linux@gmail.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 77hqdmm6ddgki8p1738jr8cifexxess8
X-Rspam-User: 
X-Rspamd-Queue-Id: C5E9E140002
X-Rspamd-Server: rspam05
X-HE-Tag: 1754936710-703510
X-HE-Meta: U2FsdGVkX18VL5nSjUL2bzD/bgKMen827JSP26sJKaAQzZPD/d8CSFRfre2w0lPZup30sRcn0PVwynE+0FISXlEsSEQ9SWf6RYiY23OubykUrNXauV7hDTnzYMDX6aMOnY6FlX1JBAPhgFu6n0iuE5dVltD2MAEVMRLDED2zFAJtUC6zLnhxNiwqhsrLe4XJWQNRt2NNilBOkmVKwbA+K0von8pn0oBYp2c3N/ap54KMNlUOOCbbYGULx3Y+Z0MKEygXGayVCC58EGnTHwNie/Yz583AWq+IJNq/HOOOoKLHbjtL3t46IsnlJoGPDOXwHx/Q4Y8V8WVFkuG7UVWLXeYdGgc+WILpNDev42aiU0jB9MNNS4f2uwXpY8HzAg33XuooM8QQ6st53J0MMA4jgRWy+jNs6dNtS+j4dsaGgT/axHHWokBTz1K1j9TE4nJXY39mUIrq5yn8SEA+RsXj96X/ZZiju3/erlkanuWXYSf3R5G3bc0IDF03K2zer9asZr8DZviwBRmOwloLOYADvJLDvsVp1m23ex25VAm9eFhW4UdLhZaERv17m8U07CvO6zeuVFqZYWaGQUkVSDtjWGhDpTt9mlg5f8+CuFr+dBIjpaTU2iObum+npHn15b60EQkk8CyMgby3Az3ZLFXazLC84uvT2f0MRFRI0ESqYj+bH/q8E931tnfi0MCcKKhhGdCD55xHXY1niB+VclNqnYUUonxfYM64+D6nSYBjsdelCUC1Q+1uFOD3EuTvCwYtY3SKXRUB/LAYPn9jc7fel+LlJtWx2RwPiajglVqv8p/Z8k7aulKkx8qphGjVQ+7DXv6QY6kUKqG7VnG+T3xNuLQWXwzXfDneB2NeUosgO1uXK6G61bKiQzAKSJds4LdrpHGYS0V0Ss7Kh7yQH+7m4tdjkJSUGfIV3qhUBpEPAhXaTNuAT9XamhjEFoJTvnLGq3TCF568IT5JcVPi9CN
 QSyomykK
 Ordb9MxOQOrpnBlopxo9czVszY3q1Iz24bGZyTfnOYPPnQyERXJc2HF0IpncBMvAhsM5ssyK40YWr6wX1E4bJ0Rp+yzxpDYOEM7sLZBi4Ip2vEs0g7IHVenq0OOBJPbspL8HdodKclQKa9FLG/z+deFySgnURvVlaybDhKL2G352LS3jnutHdCnJWv2J4oJW0tiTt/c7s+G7XakT7nXnlsfPM4NnRtEL2q4dJTLQ2xh94YtIuM4ic2ZUZES/+7QC8ORAXqCr46TtJ8N7NUXnzmYDP+djuFsMtIRV91COF3I/nd0hQ2ajb6AojYH2jYnirQJSotmyG+JYXcO8D7M3FLTrtcWK1vZiAfyVMnR6OiJvniLDqM2m/0aaZoVDBkwY6sDX1YyNOrTgOZ1u6F3utpQo07qyA+8Em6PJapmb4WsDKIA2yefu/2A/2GiHnRL+NlT67To3ZjMCEotyiULc3a+FHrjygDrEFlV5qd6rOAou84QXyzDI4ME2WKmtnuunIMsc6dBgfT1gliCIgqTrqRT0k0KLidDzcIGjbxSgTUDIZqDzwIUjsOBgO/X5Hzpjbf/6qv3+Me6p+TWlg2SidEIbSDu/n/hAEBFZclsbZxKpxFcCoWdunaqp3ulfKd9i06At+64rycuXOKoMxAeGRC2EC48YPs8+qq84LVrXAZn+WSUXkWsMuZtzmEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When !folio_is_file_lru(folio) is false, it implies that
!folio_test_swapbacked(folio) must be true. Therefore, the additional
check for !folio_test_swapbacked(folio) is redundant and can be safely
removed.

This cleanup simplifies the code without changing any functionality.

Signed-off-by: Jialin Wang <wjl.linux@gmail.com>
---
 mm/vmscan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7de11524a936..9d4745ad5e23 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -985,8 +985,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_anon(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
-- 
2.50.0


