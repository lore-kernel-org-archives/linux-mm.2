Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2649860A2615
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=NeXkZ2oS;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=fAqjDGH7
Received: by kanga.kvack.org (Postfix)
	id 591CB6B05B8; Mon, 16 Nov 2026 15:04:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5286B05B9; Mon, 16 Nov 2026 15:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E35E6B05BA; Mon, 16 Nov 2026 15:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 093106B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F7C7401F6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:33 +0000 (UTC)
X-FDA: 85442059626.12.5897FE5
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCE9C160002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NeXkZ2oS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=fAqjDGH7;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859471;
	b=n+XmqKPUQbQfHB6+6sXft0C74VCKCX4aXqEzA42UNOsua4V8sKXuRNk47o/KhDyi8RIF9X
	n6LVo5PFPd2JkffA3vbGMuQ+Mkh/8aE6/00PSni0kiE3PDTGs6F+NhAnKvRgJ6PqGOfwRv
	UCH05oQWsZAUDTNMXEf25rVVOvNugSo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NeXkZ2oS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=fAqjDGH7;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RP1wf1hEuo72YiQL0ApBaCY3IcmJDKYfBXmWsofzDvU=;
	b=Ro+78oKM/LnJQHFOt8V0kdXO4qD2OF8UGbUI6A2um8VtrcAQf2dP4pzp4dWlsObpQiarK+
	u2alNIjD63ECelCsKYMN5pxVpiSZXegtcBW/Y0H/TWwqCqZZ04pktWSpaY3Km8by1uyM2I
	6S25OMSJkJWoEKim7ogI6y/zs/os7qM=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXJcQ3840589
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=RP1w
	f1hEuo72YiQL0ApBaCY3IcmJDKYfBXmWsofzDvU=; b=NeXkZ2oSCUmIAaaLYlgD
	uI0urTFRReiqOS0PvsckuTfbI6O7HzwGF99O13+Ri3hvgUi04VyxO/eE/d+9Q0rv
	VBcdlKKP9zpqDVJIsDK6v0hi4ZGLRkpfxN0r2Z26rQfS7wWQY3Q6m8jDuLNA+tgt
	jar/IbiMngx/UXHys2m9quPZl1HFs9ujU6TIAXHJAPANcOmNwjzw+JzZL14wGO49
	jBf/4XOtLGZUY88++QHpxYrcktVlaBRwCsVOJj3d3jj+GFBd/Jtei0DpLMEmlDae
	IDzJhFjzLEkuKdedu13llpY3cU6zUGvCHSXMgTXWNe8d9T/IreVwKLXITU+rBxgg
	cw==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059sj3wr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:29 -0500 (EST)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-99c47fe8cacso3295593241.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859468; x=1795464268; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RP1wf1hEuo72YiQL0ApBaCY3IcmJDKYfBXmWsofzDvU=;
        b=fAqjDGH73oBxbpG4eB5xywubWADhIFEqoKPw0HBUycWXMjNaRmP/LKY3jJJOaNZmvK
         zzlrn2kUTVzZI6VGasnZKyb2fPqcWLBPy5gJq9iPdQX/+XmjTEGsqXlQFcgyDKv/dgeP
         PA20sAvoVkR/tNi4xk4WJmgYQ5oG3PbWpO6XUZYmcEvYd/eiPZZi+V7u8GvOCmLG3+de
         s/zRO9MMF+i2vxc6ieYyDetP3N8cXdO6gEz0ka/OMlonX0tmP8M/SzuyzPI9ZlMYoMjQ
         wx+lfPghnbH5Wf98LoEPmAFP9s2joeL7AR1jeeEEyl8JWwcGM8HWOQhK5kzkZGwNL+dQ
         3gxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859468; x=1795464268;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RP1wf1hEuo72YiQL0ApBaCY3IcmJDKYfBXmWsofzDvU=;
        b=HpvZUO9rnweMwZawqxykQL/CKsRiiQxvWXhXkBABcJyOxM2ralT6C9bQeTNYyADI+u
         y7y/orjxhNURSXEiJc4OLJrgPDinF0oRfz0azh7gmM4is0wa4wvxZPi13oSYx1Blexa4
         M/NpOZ4ReUKfAXghNWimkCQ+qTdR/E9JibRAL5yTdUPJjeQYOkU7Yn2U4suIR7UogvAX
         IoRQPxqrVeNs3RSr6t9cyX6BHSaoWP59h6OtPZy0qIULGPJ8rBjACvMH+pmNcbENxrre
         SLUxzI9Lh6RWiyVwb+pRwT1qfRdQeKXO00AOpDev+UaVSP8P8x/XXmG8PZ9WgSbIysqL
         QZXQ==
X-Gm-Message-State: APuU4Z/mkiZtI0p/nTsKIdzl968u9Y0OpwP8D2/lORY9YS136OWSiGj5
	w39mNhcGMrF0HeO01rmKggHUX9PzR3jPdTGopmIb3qsvEK4sjpl/GQ+QZrMYV7Ae6podRuLfI7a
	hojdMsTeGODyWiRSL2j0Lbavf/Cb9A3WOP5SMdIcbDFHUsEGk
X-Gm-Gg: AYBFou2xzaTrAtDhftNZ+msZirW8GJdbUu1/+f5c3DMJ0FhgGkLsDzMCcsdabPXvWkc
	Isyr7xeZZN/hM7UVCi2GEYjWI8WrHDesDxCE5atdm+2u1laZWFl3ugXqsRHgk0tXL29Lt7V4fKM
	7Mu6L9RJC6/ww7jH3Fbg4AdiTf5BGHa3ytlBlARyGM9+A1vblxPvDQGuwqviHyOyeojnEAH4208
	zuEhkt8dC/H7yhTUQOj7QqHWHzIyqaqt0dEdx4viWEK2O73uwVZMxxjvAVZEx5vh/otvDkoLN6o
	TI7K+Ab3IYfyKb5Isn96WCHSAxJNwAvqTsjr60IA61uqGKpXIpHOxtjlUub7f+/R/ZbDlHKZMgH
	lKF6eUO4adbNROQcVa2XqKamFFlASX2u8OvAgoHJRGdLOcZYZcEdIEynmfXLGGFNPu2A2cFEMlg
	MVhNlxHXkBpwFe4uDgl/1o
X-Received: by 2002:a05:6102:6051:b0:7bf:74c1:b607 with SMTP id ada2fe7eead31-7d64daf59f9mr3933624137.34.1794859468268;
        Mon, 16 Nov 2026 12:04:28 -0800 (PST)
X-Received: by 2002:a05:6102:6051:b0:7bf:74c1:b607 with SMTP id ada2fe7eead31-7d64daf59f9mr3933565137.34.1794859467689;
        Mon, 16 Nov 2026 12:04:27 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:27 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:45 -0500
Subject: [PATCH v2 3/9] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-3-4397a0196479@columbia.edu>
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
In-Reply-To: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        stable@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=6344;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hGDNR/WqM/YeXKLh1H2S+/S9/vDNdjLF5ztTsvussOE=;
 b=QTpWpJnwJIh+mIuTvkIO3+HUHJtrN24GfR7wSh+FX2cPRK20cyW4QzZaaZbm1LdVowblm2J1W
 y50qXyD7ao0CafbW2U7VPMkfpKDGgMVpA5rsNKJ42d4IZB+tSvUSyUX
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX1AMCKC3lO6N+
 ehFGUXrTGQNoE5mWaE06nb5qyfCevkezxEjKY2U8l+E8hiFMMC08C3sSMeCjgOeF0Bwpyz7Yrge
 iXMZK6STTmQQ6ZEn40t6j67IG+1zW9zsdCdQ+NAqphvQFWiJd27CQiHNPPF+LnRtRRDlwNhBJyD
 BcvUs1fz6eGWirPHG3zB7jsoSYAeVLTK/ZUS9+i3+9IylaXMHtom4bb/2q1yqfBCht5C5HV2UbZ
 d/q2lzZnewcxeNUdaKa9IJWGFnO1W4tyVE5iZfzu38+v5P01yPaF2SSk6ooMav/gznd/jbWsV6s
 zHr3C8OKg8SiwU48sFfx5/oA/ptSMAxVjjhMeBoY3Bu7vMF3DRbB/odLnvRghONO64HObUk1BW5
 f5/D61lUio5rD8DeR3NS4jeSWH6RzdY1FShhgoKAjALgbyAPhW2K9BiMweS8O6VxiqlZ+gSu1en
 LH7Sq0MR79M7V8G/UJQ==
X-Proofpoint-GUID: LMfft-dJ2brKnpVvCuPWRfedrFOe-B9a
X-Proofpoint-ORIG-GUID: LMfft-dJ2brKnpVvCuPWRfedrFOe-B9a
X-Authority-Analysis: v=2.4 cv=X6THu2Te c=1 sm=1 tr=0 ts=6afb61cd cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=xNf9USuDAAAA:8 a=tHa68p0SAAAA:8
 a=lA3VTUfxpHkutY0wpvIA:9 a=QEXdDO2ut3YA:10 a=TOPH6uDL9cOC6tEoww4z:22
 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXzL4Q5mZD/bAV
 mVYChokBBQSeNDAoi+jWH4MBj06Eh3eVZIL3LXQgyQa+XGHod47qtAf2bCBUKDdWqt6UWbCAObT
 1zgG7VD5yx4PfowKEJsMNVS/gCIzGb9AWxNTJPDr3qBlqctRaLEc
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=10 bulkscore=10 spamscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160080
X-Rspam-User: 
X-Rspamd-Queue-Id: BCE9C160002
X-Stat-Signature: 4zh983ff37ydozwgtqw5niw4xsn9gn6p
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794859470-791869
X-HE-Meta: U2FsdGVkX19YGbwOyGACkJ4KO6bsrUC+ciIlMVrrSHpvo62ehgeFi3dMyQPBU/s0PPwPgc115i3OgFRvjyFgvxolL1XrUgfeZPI/Ny6I1wp2aq2nmr9zWnWCb79RXRuFb3CsRqzhoWXUJl5of4BNd9PmuKBDN98olRKD5KiIxNbN4r1QUfGlM/3BzXD09gDD1Payadld8bono0ZdeKwuvb5Y0IQJTFuJZpKBDURG/0s4vJ/N9j2pQ3KGou+7LTWVcEqOa3yuniWaqSXRXwW4pnyheOAv9XjewR70Td4WfMhk8sz21rTAXp3muD7NqOkVII52ZJdbLL0V75LSASsz+GGLHtzHe1qWobgwxcLSPGKVQM9vqqV6HyunZjz2BntiRX1LHlusC19/tHzFjkSFuDW/GEdK6V0T/HPI6m/6NBP7wBA4hMakFc7/BOvhi/jxbNq29EwldIEcHYoPdNOuOIrSUxnKALQ4sge7QlSUI7E1WdiD9NY605WG9ySMX6UnO4YjIaD2yKsDA6dO0CqDcQObKnwsqrFHtiPTXPVDIyV6GJfe9bOOyGGkYfHv8ii2JQGzA7rdGIQmKVTF32v55waqp+ca1uyrMumNoJaX1bzgI2O7djIssbK4CNOyrVse++LOJEAzzGlIDYjXPidwv+EZkV03vu4PiwYzTNVxB6u0uZ/7ENkYkvnDXj1ll5z8Otxyuex6ssVtod5/J92cMwNo8r+SqP3of4MICw9OdJJuuaIL6V0DH8ugFAV4isB2r6v0y/Xc91WSHgGRtrdP/7BfokUDUxThAUN0kKi01On80MUoDfDav5rEPDd1ivFlsBKU6copIWL3gD/Fbm4Y7WJVzDmxkmQQevhH1qJoBJ0B43Axq/bfsi9Hj8Lvgu0dH7Lc35OIgoW3Mgfjat2S/GyYfDIDGosQyx/jQ78qrQbMsY2DpFWyAfbhm0NNJfOAinDOJADEhQzkL2nXNA3
 Z4+bpXni
 ZgMA4F/9U9sHvxgAdeAmn6qtlSNwyeEwE5bH/yiirgODbSUujtQ3yT/C5aJscFINhIeEV0mYCm9Gf4SOVcCNrgYLYBFkBXPQIGom5y0HnWERA+wk9aFw40iQUczTT0AEUZDHYFaFj4A0CQa1T5KIZNTmNhHWHJkm6lpFFYZw97gWOnk4W4cQPVxv4UVXOj5OiJRBA8O2mWfjMmg/b7I8u41S7ywPq4duDtQyubhnsW3gQTXRS+Nc5NvKccQJ7+KGe4HgDiYSkQMR3TKqjT390sFjMRAIagkv5jU8oUXYSWsIfk/koWQxtP9FmleyKOdaOFvXlavZvEVdqlZ6bm9QV8sh2YAajgJu//uLBahzbBhn2i3gNcSeLBn4bmxLcjDeeLt5kORmdRWWb5wBcOQWib26myvwGw3CrMbz8NtfK3DMXnaS5pE9XD5uy7/I0qp4f/MIAjYjofwhmt1N7REsTM++7v5/G4nX9e8nKiXtZQ18vKm++RxDMFuAqtLZf7T0oqYsicT1IB/iMwh0qYWd/OzcFm+J9XFivQbuPbPl5yjpKpKrAMye7+rpO+XnRcrJ2ynN/sdH8IUbZUTfhcuDZn3fqWQTJtKkIp6xzne3svrbZk9bJzFp4xy5XAsvirsynJdyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA
registered for async uffd-wp, and sets the uffd bit on non-present
entries as they are. An entry with the uffd bit set must not be
writable, so that the page is write-protected once it is mapped again.
change_protection() therefore downgrades writable migration and
device-private entries to readable ones first, but PAGEMAP_SCAN does
not.

For a writable migration entry at the PTE level,
remove_migration_pte() restores a writable PTE without the uffd bit. So
if a page is under migration while PAGEMAP_SCAN write-protects it, the
write protection is lost. A user tracking writes with async uffd-wp
sees the page reported as written on the next scan although nothing
wrote to it.

With CONFIG_PAGE_TABLE_CHECK, setting the uffd bit on a writable
non-present PTE or PMD also triggers a warning.

To fix it, downgrade writable migration and device-private entries
before setting the uffd bit, as change_protection() does, at the PTE,
PMD, and hugetlb levels.

Add softleaf_is_writable() and softleaf_mkreadable() to leafops.h for
the downgrade. The open-coded copies in change_protection() can be
converted to them separately.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/all/avNEgmvYdoukt6MS@gmail.com/
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c      | 40 +++++++++++++++++++++++++++++++++++---
 include/linux/leafops.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 164b4efc5e09..ee7f509d376e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2405,6 +2405,25 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
+/*
+ * An armed entry must not come back writable, so downgrade a writable
+ * migration or device-private entry before giving it the bit, as
+ * change_softleaf_pte() does.
+ */
+static pte_t set_uffd_wp_softleaf_pte(pte_t pte)
+{
+	softleaf_t entry = softleaf_from_pte(pte);
+	pte_t newpte;
+
+	if (!softleaf_is_writable(entry))
+		return pte_swp_mkuffd(pte);
+
+	newpte = softleaf_to_pte(softleaf_mkreadable(entry));
+	if (pte_swp_soft_dirty(pte))
+		newpte = pte_swp_mksoft_dirty(newpte);
+	return pte_swp_mkuffd(newpte);
+}
+
 static void make_uffd_wp_pte(struct vm_area_struct *vma,
 			     unsigned long addr, pte_t *pte, pte_t ptent)
 {
@@ -2418,7 +2437,7 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
 		set_pte_at(vma->vm_mm, addr, pte,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 	} else {
-		ptent = pte_swp_mkuffd(ptent);
+		ptent = set_uffd_wp_softleaf_pte(ptent);
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
@@ -2477,6 +2496,21 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
+/* Same as set_uffd_wp_softleaf_pte(), for a PMD. */
+static pmd_t set_uffd_wp_softleaf_pmd(pmd_t pmd)
+{
+	softleaf_t entry = softleaf_from_pmd(pmd);
+	pmd_t newpmd;
+
+	if (!softleaf_is_writable(entry))
+		return pmd_swp_mkuffd(pmd);
+
+	newpmd = softleaf_to_pmd(softleaf_mkreadable(entry));
+	if (pmd_swp_soft_dirty(pmd))
+		newpmd = pmd_swp_mksoft_dirty(newpmd);
+	return pmd_swp_mkuffd(newpmd);
+}
+
 static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 			     unsigned long addr, pmd_t *pmdp)
 {
@@ -2487,7 +2521,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	} else if (pmd_is_migration_entry(pmd)) {
-		pmd = pmd_swp_mkuffd(pmd);
+		pmd = set_uffd_wp_softleaf_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
 }
@@ -2557,7 +2591,7 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 
 	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				pte_swp_mkuffd(ptent), psize);
+				set_uffd_wp_softleaf_pte(ptent), psize);
 	} else {
 		pte_t old_pte, new_pte;
 
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae3234..4c016fc28690 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -434,6 +434,57 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
 	return folio;
 }
 
+/**
+ * softleaf_is_writable() - Is this leaf entry writable?
+ * @entry: Leaf entry.
+ *
+ * Returns: true for a writable migration or device private entry.
+ */
+static inline bool softleaf_is_writable(softleaf_t entry)
+{
+	return softleaf_is_migration_write(entry) ||
+	       softleaf_is_device_private_write(entry);
+}
+
+/**
+ * softleaf_migration_mkreadable() - Downgrade a writable migration entry to a
+ * readable one.
+ * @entry: Leaf entry, softleaf_is_migration_write(@entry) must return true.
+ *
+ * Returns: A readable migration entry for the same PFN, which is exclusive if
+ * the folio is anonymous.
+ */
+static inline softleaf_t softleaf_migration_mkreadable(softleaf_t entry)
+{
+	const pgoff_t offset = swp_offset(entry);
+
+	VM_WARN_ON_ONCE(!softleaf_is_migration_write(entry));
+
+	/* A writable anon migration entry implies AnonExclusive. */
+	if (folio_test_anon(softleaf_to_folio(entry)))
+		return make_readable_exclusive_migration_entry(offset);
+	return make_readable_migration_entry(offset);
+}
+
+/**
+ * softleaf_mkreadable() - Downgrade a writable leaf entry to a readable one.
+ * @entry: Leaf entry.
+ *
+ * Returns: A readable entry if @entry is a writable migration or device
+ * private entry, otherwise @entry unchanged.
+ */
+static inline softleaf_t softleaf_mkreadable(softleaf_t entry)
+{
+	switch (softleaf_type(entry)) {
+	case SOFTLEAF_DEVICE_PRIVATE_WRITE:
+		return make_readable_device_private_entry(swp_offset(entry));
+	case SOFTLEAF_MIGRATION_WRITE:
+		return softleaf_migration_mkreadable(entry);
+	default:
+		return entry;
+	}
+}
+
 /**
  * softleaf_is_poison_marker() - Is this leaf entry a poison marker?
  * @entry: Leaf entry.

-- 
2.39.5


