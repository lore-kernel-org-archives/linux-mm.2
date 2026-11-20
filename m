Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDE9606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=OiwPqAIv;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=JAG1NFuV
Received: by kanga.kvack.org (Postfix)
	id 69FA66B05B3; Fri, 20 Nov 2026 14:51:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6502C6B05B4; Fri, 20 Nov 2026 14:51:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566446B05B5; Fri, 20 Nov 2026 14:51:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272306B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:51:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89D65A1248
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:51:39 +0000 (UTC)
X-FDA: 85456542318.05.AB2B0EF
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id A655020003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:51:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=OiwPqAIv;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JAG1NFuV;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795204297;
	b=p80uwyqP5VCqbks5wgJr20ke4YALY6Hx+1a8WU0yO4stwo5abfWq+ggEvmxAdMNnEJstfp
	9/lbpSYkmNC/rpriV/Qm3Jxc8C9ZNhtjM8OOGdFPnD9YpEMO+pFlEZ78etFp7qxWY+9osU
	zROF+x/aHMWRL8Ddc6ENaDRLQBQB1HI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795204297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9cJLPnhCCqaqzy8xIMNIAAGiCcr8uWzwwAnlQW3eAlY=;
	b=0TiAoU/VqJAvii1yUl0DSkaYmMdQ99CSo/ee3zq9pqlPTCMBsS5MwTHum7VUuFXoCGbVLn
	pikmPyJdbZYn8q+aF/fJj4zlZjUYiD3glAMjNjrcyIsioq+saWm6w2Wa3SGAwb/zFtVIPj
	yaoE2eGCBpJox+LY94DbzNbx6mGZS/I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=OiwPqAIv;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JAG1NFuV;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKJYYqh1156904
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=9cJLPnhCCqaqzy8xIMNIAAGiCc
	r8uWzwwAnlQW3eAlY=; b=OiwPqAIv0AlmHcxdo4Y6QFyYubrXY+Yz4DMcIulK83
	2VXN1xXuVHMMtZ3fPkgwvBhhRMjc8MzgAO1oKpwgzre78SrKviRBY073I0LxNrDN
	TG4Ab5/g5dwVJCJVNg6/kQq5eGcW0Zd3UU4zqj3fBVb02QZhubtNq5pJDcjeIgAz
	7sEZsf+01//69AoC4NGo6m/zCQZVOzscBPjf9LHp798DMzY9OtAWcszkiD0JEC13
	6bfH0hqZ+cYo5FZszYqdkpah1ttXRDJoGqFTEIV0z2pw1yy7IEO+Juvw+P6iuWn+
	T7pojjqdqpSHmDCDaSwmwTffscKaASCnVhmRwYcQ3MFA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j2ss59nv4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:51:34 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-94960bd17b5so220095085a.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795204294; x=1795809094; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9cJLPnhCCqaqzy8xIMNIAAGiCcr8uWzwwAnlQW3eAlY=;
        b=JAG1NFuVZgTlxzSp2fzpY1kYWsJVwwvM/ia3qrlN31vntc46wW55jmJ5DQqbSfpHd/
         SDB5Q5PBgMQCgEfDfLMJUOSYeIqrp8N9Ku3gqfuCsjMeg6W9AECRiFmrJ4tYpQuaY3qF
         xr9FtHydfqRnmI80guc+VkopMr2dEOgNEJLR8JPSw23Q6+u+/njHXDtWpDwPso4/GV7h
         hP3Tv1XthTqCSsRinXaJ9Yl3kOqhR76ACmCSBNPVDM02q15YX5AOigDU8LwtwAVF1I+8
         m/Zkd6ie4D1KfavgDb8BaJS0zOJ5Ev2vbpfTMRKB8ptYZKVjlYPS/wcEWBhFYEwoSxrr
         zFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795204294; x=1795809094;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9cJLPnhCCqaqzy8xIMNIAAGiCcr8uWzwwAnlQW3eAlY=;
        b=wrTFSDEEPPVX68tTT6rkYXh+ArBNsJ5LlaJQwzVUiwkx6ZrM/Cb8Det7aFAiq9LP78
         W4dWJD87A05HjlEfRrtoAvS2u8ezZ7t9bL9vk360FcQB8iqgdkDlr3bG8BmxRsHwpgk0
         Q4dZKXn7ovo8Dd/HNtaUqjIFVD24qKwWUEGcdaL43X+5je0bC0Y6cKF0hYf+NJT66EQN
         Y1GN2PsqzwhoVuj/aKpJSCAVtiqphIq/rqI3RM9T+tfpvZyMyQpsJQvMGp5RnSS4kDB3
         pOu6MVmjslFZTZuosTXIhe4TnhMMHrlMhNh0rKG3KhIc8USnsNbAJXKPTJh+vqZRSsxs
         Ww9w==
X-Forwarded-Encrypted: i=1; AL+hErGfLZib72NYrH2KBQOtJ8Ao0Ld6DzAqRKYLIDqdSgrJAciNLdgrijbpTOB1NCTPamkq6YhtLH4opQ==@kvack.org
X-Gm-Message-State: APuU4Z8WK7x4eqqNOFWR7kEAx1ZvsBa6ldE90auQsAV8Rx+hfAWS/xLx
	NG+Bc47/rYD49PwujdMN2Wmyicp4q85q/okU9QwV6mRZLfEQ/+q5JvFUKC2F/Yu+KpdYkas47lv
	byiiSk8n9ltlup80pj3MZ+H7X/kHgDpT7dcsCaN20Pt1mjhCV
X-Gm-Gg: AYBFou3W1D5YFKFhSO0f21//j5fad9fcGsUvpA0ijAItfD/IlmaXFemX8hXSFKTwjEO
	xkDYP/IUF4Ui1KOuy6nsJkGZTvAg0vAKy/0LM/JLb945wDOA1XA0Bx9RKYEhN2MAs4wryst094B
	W/8L/tu+xAK7ZYUB2Ig/MXEFV2HLLnOXHTySfkBMzMkcFdHUXFeP8yKaD2hq5o7pupVIGsv/1Qb
	rqzIcaHwGa8NKJgevQow8lJi5qobWw5ots/wu+W6SY8nqj19MNe+bBgC2OozleR7iMensZJRfRf
	qOV8LMAgK2QYIZAzvMcsxAu/XggoocMdvNmyfnwcsgzgkrDcoAcRzOTUIlpStUWvI5KXqPMTqkN
	vZxVnclkyP6UYGc7iTiy2eMORCj7+8pDRYUi63DWZg2lW+36qTpcn/3y3OfJxF7tT9aKTSzQrLk
	10Xkin7bll/+AC0OTwGerT
X-Received: by 2002:a05:622a:2283:b0:535:1b18:202 with SMTP id d75a77b69052e-55d769ea03cmr72999981cf.16.1795204293769;
        Fri, 20 Nov 2026 11:51:33 -0800 (PST)
X-Received: by 2002:a05:622a:2283:b0:535:1b18:202 with SMTP id d75a77b69052e-55d769ea03cmr72999741cf.16.1795204293341;
        Fri, 20 Nov 2026 11:51:33 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-178-217.net.columbia.edu. [128.59.178.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882c64fsm31402251cf.10.2026.11.20.11.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 11:51:32 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 20 Nov 2026 14:51:17 -0500
Subject: [PATCH] mm/filemap: only drop dropbehind folios on uncached reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-filemap-dropbehind-read-v1-1-a373ac3fd993@columbia.edu>
X-B4-Tracking: v=1; b=H4sIALSkAGsC/yXMwQrCMAyA4VcZOS+wVBnMVxk7tE3mIq4rqYow9
 u5WPX6H/9+hiKkUuDQ7mLy06JYqqG0gLj5dBZWrwXWuJ6IBZ73L6jOybTnIoonRxDNyoO7c8xD
 dyUOts8ms7995nP4uz3CT+Pju4Dg+E7liP3sAAAA=
X-Change-ID: 20261119-filemap-dropbehind-read-db1046d9c23a
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tianyi Chen <hi@tychen.cc>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795204292; l=4127;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/dZh6qIXS8/hlDlHkKu/8ShS6WT0I5PYluolWLn5EJY=;
 b=UeFEsJv0qY/2ABML8t/S23qbXkn6Dtp7EL1LHFco0i3gugjIu3SDH+u/LHWrokzSXBiAy0k0l
 09RUZT4JwYTDbMJvOC0OLdmWY64jtjcrTDS1ZtRtFTv/MnjTJ+AM4yX
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3OSBTYWx0ZWRfX59kxoKhAP0Ic
 Qjwkl3u4UI+ThoBOOo67V8yNlnNU82eHq1HF6a5nHGj48WZ8oTNQJsCGuXp4du7wIOeDgYF/3kc
 gSJMc0Yl6oAbLQH2XmvcCyjGrSn5lljYwP4p3rq+z3tKGVF8DgNuMk9SDlwGfCmrKZpKpDnhoWP
 WoAjknn6ELcp6eGn+udHG7EnYBQZ+Iws/zxFv29zo2adXSdgF4i+gqmOfTqTfnZKYG2qBJpKOD5
 /HAGf17X9QxjxVrRNvEQbZhn/BMwoEOL9mEal4u53HNbw9G0fRIy4UmTi6yni1P1sf636tFkvjA
 6KX4c8iSXIz/g/jHNhPrhXCTZdPnSv18dJnedxXbvlw8hczmGdZHgf+eyRUW39meTCdH/MQ6Z+6
 JGmxeBOYoGLs0SfEDYr3E3/U4cso5ofLhh1z6I0/ryImF5k5YTbIgUZE6F9wrIvPDZTTjOKvlTe
 VMDX8bd/pOGHzfeX8aQ==
X-Authority-Analysis: v=2.4 cv=fJasTpae c=1 sm=1 tr=0 ts=6b00a4c7 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=lnglQuR7XRqnmjDHco/WZg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=Y9ewyai5-AkszFq4FIoA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: rLACOGlLM9Sc4dHOLmIuke_owyddU94u
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3OSBTYWx0ZWRfX+yEn8EOIFlQ6
 ny4UMThbjmBBaR6S8WCdMnTd/TfKcd88T1QNqfnHyqRPWi0TsBiV0+UgM9wBkHIgwYr5xJ7D0II
 WFyz6ltEoQ9ccqa0uzUG2IRoCwPYYXEM47Vu+bHNKBDdlG6Cbqoo
X-Proofpoint-ORIG-GUID: rLACOGlLM9Sc4dHOLmIuke_owyddU94u
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11972
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=10 suspectscore=0 bulkscore=10
 priorityscore=1501 spamscore=0 impostorscore=10 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200079
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A655020003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hh5wswda935ax96bpwpzhnutasox9hjf
X-Rspam-User:
X-HE-Tag: 1795204296-768474
X-HE-Meta: U2FsdGVkX18rTmYURc1aW1Hh6nBIGcsWG/T8wKGO9S34Y3XzkCFoot98mo1ZEVUEZS/3/NdN0x+UO0s+qbGM3VNdDRESsxvfBtI8GA6JOwEJSHxAlZ7j8I2w/vHsCxTTod17NCTrvncLpjjYK4XTQ0tUTctrlWcLK8DM/WqZUzKcJbKRVzfoHNZbDJdcLSK91cqQzJOCcQjN+1Dj3BBU1GODw+5RUhD/NTBggFAfXJJcL9MsYL3kNJrf2Nb0WOPBeVNa/P8bSEIKA7C1A8nAZ27YpF/VPZx5x8bQo2Ajxup0+/M5K8gdBkGcjyfss/B6b/RJvZnSTaDTIPcnWjYmQTDB6elmOycFx56vhkkbV499nEqyix4mixdiIx3INT509lYh0mas3XwCxMPwvt7lBlyFRNOnNtP7dScn7zODLoE2LE8nGCsoz4Ic50kPl9tWL4fFX5jBskhO90Xc5WbBDel8/Grsf1v9tNGztZhfZ+Mdh1M6mNL4KcGKe6VzytYnfPnecDWyjgNmA54ac0M8PHZpic8lA8UBWPINy86lHWkPjc6gHBjgc11Px7ZpBjInrNoBhy0uxuP2l599ciwtFsuPqwxZXsVGtnCOKWLcFUzjDECwoX6hnDEsAcqkckh+31Buwav8xElgMJwyjJpv1dIj/6x8otC6OD58jzo8XLv8Of3saZN5tdNPVVX/Jqn3gcYwsvEXEoNZl1Y8Q4dCFBDJzNgCJLQHxgeMxsgbXd1M36nZGR322WqNW0Otjsc6OJUeyNhK32nyCj3URQ4lv/3tMB8eEKJiN4j10ReL1Uu85X71Z1QM86q+d3VnERDUbSzyj0+atyjEJIoYTvoqCadBWNOhMLu0j8WB3zXx649evn3vxzXeFI100hWDrAhZMNLCAUweadySLuoyMStpiPBsyp+e/pPBH0fsNFg/p5RUvg9mwzu/4kUvqcK6jVO4cX+wjdW0vvOPS9jOTVD
 kotmHmuf
 PfVN2bbe5PYOZE5RSilswI99yERwYFx63lRLBk1fHHLO02v5SqEu5CgDi53gc42D7WXDx09JsbM6zpheNDm7mzOeZA040CXeO0cxuUZemccI0qruPyTIAdQfmGwlfG5entsLdwViJlqAnNWT6x/pu9IUe0+U0+2KeOv3a5gQwwk37xb56ZNuHvZqRZRByV9V1RrRB6yiZXFTawheJ7fLLLxq6nbkQtJG8o4eBEDBhw321k8vCsxAiOLUBHdMdisI3RAWazyk9f+e4VxRx0NMB+PQ8N1i0lAj2m+pEIE6YUvOxVkJC3QGBtf302x24EJlcRaTt4St/3s3OMQU5zZrqULg30dB8GW1fEtLPfDeppGBE1fWgdFUszHqb6PyvSoZvXReEth8tddf7w5dLLxsoid3U3diLq2uiJYbZ4mlL6J5Qeea876xG4kP+aNs/TaSlnRkc7wDO4EHlDvrsIlHE29FWvaCyZMwtkY1m5WdldckDoLNNDxna98y44jpT+RAa3jj8tX7WkwagtjDY7VsFC76OY/gahugYpsYE78P8d7JAoVirlBc0Zahijx+/m44+fM1KffNNImQ/bin7T3uoylfHCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An RWF_DONTCACHE read marks the folios it brings into the page cache as
dropbehind, and filemap_read() drops them from the page cache once it
has copied from them. Readahead can bring in folios past the end of the
read, and those stay in the page cache with the flag set.

filemap_read() does not check whether the read it is serving is
uncached. A plain buffered read that finds one of these leftover folios
drops it as well, so the next read of that data goes to the device
again. This is wrong, as a plain read should leave what it read in the
page cache. The lookup path already does this:
__filemap_get_folio_mpol() clears the flag when a lookup without
FGP_DONTCACHE finds a dropbehind folio.

To fix it, only drop the folio in filemap_read() for an uncached read,
and clear the flag otherwise. Move the flag clearing, with its
WB_DONTCACHE_DIRTY accounting, into a helper for both callers.

With a reproducer that does a 64K RWF_DONTCACHE read and then a plain
read of a page that readahead brought in past the end of it, the page is
gone from the page cache after the plain read without this change, and
stays with it.

Fixes: 8026e49bff9b ("mm/filemap: add read support for RWF_DONTCACHE")
Reported-by: Tianyi Chen <hi@tychen.cc>
Closes: https://lore.kernel.org/linux-mm/20261119035808.431204-1-hi@tychen.cc/
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/filemap.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index dc0ceaa58a0f..1bd91ff264e8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1632,6 +1632,28 @@ static void filemap_end_dropbehind(struct folio *folio)
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
+/*
+ * Clear the dropbehind flag on a folio so that it stays in the page cache.
+ */
+static void filemap_clear_dropbehind(struct address_space *mapping,
+		struct folio *folio)
+{
+	struct inode *inode = mapping->host;
+	struct wb_lock_cookie cookie = {};
+	struct bdi_writeback *wb;
+
+	if (!folio_test_dropbehind(folio))
+		return;
+	if (!folio_test_clear_dropbehind(folio))
+		return;
+	if (!folio_test_dirty(folio) || !mapping_can_writeback(mapping))
+		return;
+
+	wb = unlocked_inode_to_wb_begin(inode, &cookie);
+	wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -folio_nr_pages(folio));
+	unlocked_inode_to_wb_end(inode, &cookie);
+}
+
 /*
  * If folio was marked as dropbehind, then pages should be dropped when writeback
  * completes. Do that now. If we fail, it's likely because of a big folio -
@@ -2089,19 +2111,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
-		if (folio_test_dirty(folio) &&
-		    mapping_can_writeback(mapping)) {
-			struct inode *inode = mapping->host;
-			struct bdi_writeback *wb;
-			struct wb_lock_cookie cookie = {};
-			long nr = folio_nr_pages(folio);
-
-			wb = unlocked_inode_to_wb_begin(inode, &cookie);
-			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-			unlocked_inode_to_wb_end(inode, &cookie);
-		}
-	}
+	if (!(fgp_flags & FGP_DONTCACHE))
+		filemap_clear_dropbehind(mapping, folio);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
@@ -2918,7 +2929,14 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			filemap_end_dropbehind_read(folio);
+			/*
+			 * An uncached read drops the folio. Any other read
+			 * keeps it in the page cache.
+			 */
+			if (iocb->ki_flags & IOCB_DONTCACHE)
+				filemap_end_dropbehind_read(folio);
+			else
+				filemap_clear_dropbehind(mapping, folio);
 			folio_put(folio);
 		}
 		folio_batch_init(&fbatch);

---
base-commit: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
change-id: 20261119-filemap-dropbehind-read-db1046d9c23a

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


