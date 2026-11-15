Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6905D606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 00:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F8wcAuRm
Received: by kanga.kvack.org (Postfix)
	id 6A65A6B05B1; Sat, 14 Nov 2026 19:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657306B05B2; Sat, 14 Nov 2026 19:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56CB86B05B3; Sat, 14 Nov 2026 19:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7446B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:14:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E4D9140496
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:14:16 +0000 (UTC)
X-FDA: 85435431312.05.F92821F
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 52FA040007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:14:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=F8wcAuRm;
	spf=pass (imf17.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794701654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BowdHmWbI0HF2cyBE1LmXoTTFShzBjfQ5Hp9NB3N4DY=;
	b=DALocwkmDeyFNkS+NFbt0crd5M6cCwWPpVlJtmt3vNlVr8SncDMmSN2kxwuGL/BYWnEj6O
	YzXVC70N71vUsWJn5brNQdYA5OTSdtOpCr85Syh7vd4S5bbTifJexECTtyRaG8T4c/S36R
	xOxvH/5Q5zl22wQwth8CkapD+GwY5iM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794701654;
	b=gvFkjEsjgSKVuP9lzqI4g2ZRvZGtv5JErly5pn0qtrdA9FzM7VuepihNeaVwl5bayksCmB
	xsCAqU3g0KrEI1N1/vwgI0fjJnCozQMX8VB8kJ+nSLSg8bVYCi+Z36z6IQ2y5g59eBq+TO
	e4CVsqWPBZq/YeRbLY5BZalBunMp7ks=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=F8wcAuRm;
	spf=pass (imf17.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so19156425e9.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794701653; x=1795306453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BowdHmWbI0HF2cyBE1LmXoTTFShzBjfQ5Hp9NB3N4DY=;
        b=F8wcAuRmlDav4znqPCobS7t3KTQNBNMlf9PzngIJAZ8Mwa6/SyBzGH0xD8nBtBZVks
         JRXQztr/gt1e8CobdVc/t1tCjT1dLCp/DzrNk+8PWDKPBo2Z+s2rk1FOFxb6qUOkMG2A
         ejCMI1x1t7RuJZiIFwbztNe4PaIvBXGDjem58d59anQIQuBjiuTgVraCbza/ypbX2Afh
         onY3Jrv9q2eHcCJo8FUZnXplYefpijp4uSphDtR36GC/uDcZqT6nbZi+be0sGy3jdH6U
         e7ZnYKFeN0FSGbDLAl0CzbETQq8hnJJWD/8chPfvq5mYVn/r303cjAj/0WwudP2SewJk
         xw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794701653; x=1795306453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BowdHmWbI0HF2cyBE1LmXoTTFShzBjfQ5Hp9NB3N4DY=;
        b=qk7eB4Ddjam5cASOu0YEq9eBgBcRKaF6+RMRjoh51a6d2SeOu1ooHUYJiv34YngLAj
         j3q4sM/hwsG+gKOTbs+2VRmy3GeL4rmAocmw76RCgLp1/LAUub2Ii/TAf1D2MQRtNOe2
         cHn3y07cf5CUG3tLqqb92VX21LqvBtjDhC3FHUT+1DkMintJQE3i5ozzodaTumVKfNYw
         spmULGNudXPLx8kHqWIsNxcRpWvbIJaNEMPkKX26jFs8EHcVgGaBX6j4f2F5F5U9/TUw
         bKynHHkV5ILrtC6QbRTLApajZB/vRk+JUIujCZTGvVw5wyrQ8LZI5w0j8Ts3AudvTwWN
         92+w==
X-Forwarded-Encrypted: i=1; AL+hErF+nErFYTRW9MopUqECm7G8SIGJyvCCaaim3GsjgViYPtZX7BjHrPinynUZJPSThj90y94udoeWGQ==@kvack.org
X-Gm-Message-State: APuU4Z/U1yuEenIsTRn9//zCLkDHs8yDTfnhvuWG8GTJYVbXOi9tuMEH
	DbBZvXQdIuix/GO21kpb6XOgbPd9J6xA5lep+49z/Giew7XVxuA7B4aN
X-Gm-Gg: AYBFou0buxUQ0zZDjXMxaZebnQK6OHuBh/ge0TUCSljHLSQu/nvQQTOxfk9m8J6Ts+h
	/p+KT8/QqsspCiA8Hskty0Kvwl2a+MP2rUicN0QIPRpS12HvnuUKhajrjbA5vmdlhtwxMHMNi7B
	MhChR7yjIAE1o9mu4jSD3nRh7hGzNvoN2D9+gjmSOSzHZI+mmXJjSlVX6zGKax1/7dE9Z9lcfkG
	85xASdPcbA45jdlBgxWEzOvDC6YohNUtgdw4rFRmQo1jHe9phmHtVsEDSc0xHIV6D2HpC8SwI/w
	CH3V/bG1PdoWviZgjiULdzaYIguw6y+DGFI4zYIueKsBnzk270q54+BPkhRJMnVB+0+EXR7Bp+s
	7BrWebySwt2+D+Vr8Vf33TQX5WsLJ5G7W0kF4jlR1qaYtW1gl0CUea5f8Yvaki2n905AmSvsbBn
	YG/d9NEPIv9AHNHgKrwa2OrNzfTKc2oV2uUBeUKGowZA2IbYlW3EUbY7wl9egF8pkg7V/WxgIVY
	tRpOLAvfKHbfo5bEKHpdhqvJgPSECv4XBRjp4eoiXZchis+OAlMobdi7Y6aEq0/V77bk2tdEm7W
	WNiNLwXj0mriD9aGeO0bfkOSC5lmGIMcRWiQ2crEODsNmV29JxOokLGnQnI29wZTlexB00KKYVP
	OcfNXYtqt5K8=
X-Received: by 2002:a05:600c:46c9:b0:4a3:d327:6ed with SMTP id 5b1f17b1804b1-4bb55a5fdf6mr148913485e9.17.1794701652783;
        Sat, 14 Nov 2026 16:14:12 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.. ([197.18.115.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ae4414sm177925125e9.9.2026.11.14.16.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:14:12 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: willy@infradead.org,
	jack@suse.cz,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
Subject: [PATCH v3 0/1] docs: filesystems: update VFS locking documentation
Date: Sun, 15 Nov 2026 01:13:33 +0100
Message-ID: <20261115001334.23026-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114235426.20408-1-mohamedalibouhaouala@gmail.com>
References: <20261114235426.20408-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9t81d3gj8zmq1qcruj1zwhd1k9txye8f
X-Rspamd-Queue-Id: 52FA040007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794701654-314964
X-HE-Meta: U2FsdGVkX1+BoPK3jwIXQdSso040HdZxMTnMLtrE7Lswt9S7gxS7t/uZSCTdwmtUHIbkQVmKG42AV7lbvU8dnEACp8hAnEwbWs7DZyiFywvkm33nWXKMOmJ/dvsrqsuRPH8pbqE3pD2yDtt81DOYProXB8HpTMkui5lPJ+b1y3rDXeKzJB/OlGxQt+mSGJWOyr5EJEmQrmVMr9Sps0uaE4zzF+lDsOaiYDZ77GvvbHv0xGOmuu05JU7Pt1HCHqPCIqmLC0pjOhGPnuadmaHfi8ZMxeXHp8b4a/XWUCG66UZD+V3TwhczccH9EKcliQuCM5JvuFpZcIfCZtCOKUBgh2sbXRDRH2eZxSv+Vng2QR8EK40bB2B2qdCpSJgAWKhsAKNe5DIWmMoPzW26Ox3mYjdMqrJ9K6V0gACG+EzCd+waWw53lyFSik5S4BaNWOCdwONWbmYFiyNOn4NFoum6lae1YBbYFq3Vx/Llt/GBWRhawtVhvAr+YSk6Q/SEgOUfPbIihCkuKMFyNALG0sVBA9PWrltOKpqWkxiKKC6Q7L7iESD5s9uaF71wqumLq2XNvI+SC/N+utkNhnvq7f1stQqZcS5uHR+d1GVwSQUnz0unYItR3HYaJ/RoZWRFbypUaonBqwIW0FWaAarJDaj3z6XkQSQtlgzcgUAB8HTs+rfnBcaXxHVpv494upPjuJF2gwg12l3PEKI/C0zZ8yi9DBC97wSSHlkcwi8cZf088s/DvQU8YcXaE9XhhqsVbuXTqOMt1ivyWvv9MWuTUXQGcjnINuT/3ulFi+BQNnbCwjAVCkRB5gVATT9mlCiyl3SPzdq/WLeZCNui8bFMlry3BiKyXGfqsL/9WZ/htRiQ9DG0+CXVvwynmGOaaArfdIreEa5QhR9E6j9+0nBEq0RU4az5VGVwIrDjn7S9Bp6E4ynRtn9a48iOGFWI07h69E/9fPNF8SmDn/7OSg0UmGC
 xtBGU0qR
 1oydJFlFn8pUCZ9eX+rGlgcRAUdHrMSNwZM+FH82RRbgVMgX4tA2Bi9sgnc72OE1xbMAjl+/rjKAAfiBxQ+GKA7FlbbSg7ooOC/UVyLdZ1TpmkI7frVya5h9xgbVhfAhJjlL3wuWBK2TuBywECykBSUABMsopZZweG8j3rUYWMiEKdyT79cPxPvo/KVMwYeyb3IGVvNUwCYibKmpTOvyB/hx6U1QRIDwPqUvhhc93lYrUqF2/tkdk3U6p4ktE4iccrMSX+vGy7jRnDntvf+dhdOr2bWzkOsX3NFT0pXv0xIoNZG3D/eNRX3e/F0h1OqJx+OtjsUajLbWEOmg52zPHqncYoTRlS6+N+wNamJkAL7seZmIoZQQUmSJKJA/2uXYk7RBLTOWGXdzhfpTsTUdjnZUJuXH90wzYTJ2DGq0sJa66AHb6B0IF+ftx+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Apologies, I accidentally sent v2 instead of v3 in my previous email.

Please disregard the previous submission. This email contains the corrected v3, rebased onto the latest upstream master and including Jan's Reviewed-by tag.

Thanks,
Mohamed Ali

Mohamed Ali Bouhaouala (1):
  docs: filesystems: update VFS locking documentation

 Documentation/filesystems/locking.rst | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)


base-commit: 23c62304dde29abe92013d85910d03a77dada35d
-- 
2.43.0


