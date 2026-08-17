Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A873C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93BD6B0850; Mon, 17 Aug 2026 15:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BCC6B0851; Mon, 17 Aug 2026 15:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5846B0852; Mon, 17 Aug 2026 15:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4A986B0850
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25BDE16085C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:23 +0000 (UTC)
X-FDA: 85111714926.08.8C2CE14
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B8B1140006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=LCWw5JIV;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=i+YUyrvM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DggvESa2CSpFGON8I8M+asVXtRP298nD3FGbSrEXKPU=;
	b=gK5PKKf53XJYGTPYFPHGgQTl++94jgkbkqjhDmVTHno/04cYulm2L0Rd0Bxl8I0vlNjrHZ
	fQ08X/y068lcc2x9JbwAJP2PTFL1c/qzkjFjpeoN+Noke78cUQQTzH+ubsl1TTVdnQug7Q
	GIUvHRHeuDBYf3vs0XkYqFFQZ2JcTHc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=LCWw5JIV;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=i+YUyrvM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994120;
	b=jSZ9DKNyFc4nu+6PML7GsCA5Bn3TUCPQlk/RTHKk/TNR9VAv7J1AfnCilsshGTBkbLaJPH
	3loLW2aepsaI7Bhx/Xe8wJokHYi3zPeCglkPRK/F7NAKEegurSxcrOHIF5KhfrckikO598
	WnwfHxKjg7PZEs+hjiNWlUR40MSBL1Q=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIYhh24004493
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Dggv
	ESa2CSpFGON8I8M+asVXtRP298nD3FGbSrEXKPU=; b=LCWw5JIVGwNwlQ264hw/
	16CXJ97dztxkuxphSfp+yufad1UQKR+KFb1x586lzjDl/e+ek5Kl1iQptAt1xg4M
	cqHM/YeA+9lFNfY/a1WJZT7yrwIb/1DpDAW2mSiv8jYy67FcjGnAK2v2ZVSOJEAC
	kZPxB7w9HhiSM8Q/HIFgS2tgl59CjWuVy2/4tRqJhWpU1hmDGXZHE/xAWo02IRs2
	FOuJ5JwmYvwtw3wvHDY1guySZR6t4z84TpTV9IqvwyoTBCXGY/mOv0aysZXDcF+F
	zewbiYLDc6ifqu4QB+knUGJlLDrDe1C6moCgZLImDhe+OeIYJaScAO07TwSANqkk
	sQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g43e0anb2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:19 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e63df032bso27818185a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994119; x=1787598919; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DggvESa2CSpFGON8I8M+asVXtRP298nD3FGbSrEXKPU=;
        b=i+YUyrvM6sEDxglzcne8MowKLYklBHI+pB+k6KFDVXCCj34phDwQmiFL2byROZHCVh
         9BCBa8QgU9shX9/3sAmlYyisNG8RHZMV4N6qwNX9yEFgCROED0bshkRbli+ZNlCmTgRD
         VRoc4m4TVH4Exgg6I/j6jx8dqn/Wc4BfdX80nzPy5ZxrmdNt8ZEF+RUm9aPt+C/envA5
         sgpOCn41XeXwcMY5QBAdGVLFb3xGm0CxLyoXIn12Z1lDjfShCxo5CCEYD9Q+cxG+opFX
         BD+wlsiwVg7onuScURC3c5CILVKS6et4BWYsJAyt1X+0TW2Au/f7FM4PnVBlO0GahftW
         ayxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994119; x=1787598919;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DggvESa2CSpFGON8I8M+asVXtRP298nD3FGbSrEXKPU=;
        b=BK9oC5LcEzI0fuE7IOsNG5xsJxquKHMVFqQhzTylWomg/9bw3IkICrkIoVk4LnptZu
         RzgfRf/cG+5+T4vN9j1aoi1zco6D0+VWnyWlnOzLYJcv396XXEyV47EawS+O5doHCHmx
         bJv37lLpchk2NOz9+NI1it3Qb80Kx7uq1euzl/HT+SLZEtM+2TD/nYFncH2W3cBLWW1B
         bkHgtJjJAo33h/TtzT3/wMSIruQDyBoNUFbljbnQpQTADkCb/XWhHcrZsXzVEUPYNNYn
         sDnBx5Gc0oC57NNEnhQ+fBBW3riXC7kNt5/nOCSyMZUyZJP1rQmn5qiR+r6Yjcg28v63
         bfzw==
X-Forwarded-Encrypted: i=1; AHgh+Ro4CMgBfTteFq8lRzn7wliOHddga2l1xqE0d9Rhm2UNiA/vtbXDfsHeBged9UcEXzhRY2U9FfIuNA==@kvack.org
X-Gm-Message-State: AOJu0YyknLWKpjKanEA04MMYYrY4BIPxn3FqtJDcktPU7uQXm27kS7yl
	HbhASMoNLp1nbwbq4IEt5qqcJZe8ZhjqFzKckSG3Z1/pSRlf6L0E6hDiWPB0R/TKJ7Yf+RlAb2f
	1VIm1ujWXXHzMXTHVxeRAvCSloivj1nKxAwYEXHjmXvCSf/rR
X-Gm-Gg: AR+sD136xmP9PSaxlCKJGkDTEUVzEpAQZge1GuAoQVWYzpn+SL/gEEFarFRdUBTwV2i
	yMGf3uSl1VP+laA1xdD0K+awCRUTmjDrWo8w4QUanJYLNjuf4OD83058fX4h/fCrDMkQrdTP5U9
	Ee1jHwHdUXhNdGGNh4r2UldJFqSjyCKKsTqVJJtZgTjagR4p/GSYqB61HRMxH7ODSM19TizZWvb
	vXuTnEgIyCKkDi4Lud5egGDQSIHZ7Jq6Lo0AWhSF+rODmpfiuF6h3yQotM9VbYWY9KIsRLU2GuR
	8hq1PHFh4cnoHYKZCwrVDV5xhQJMGitgpqXVG8bCMBuQEauo20+Hj+/Ww9gYMbYNv3QDYLrloIS
	QMlIWIuGD
X-Received: by 2002:a05:620a:a2cc:20b0:934:b798:c245 with SMTP id af79cd13be357-9370667ddaamr124714485a.16.1786994118864;
        Mon, 17 Aug 2026 12:15:18 -0700 (PDT)
X-Received: by 2002:a05:620a:a2cc:20b0:934:b798:c245 with SMTP id af79cd13be357-9370667ddaamr124708885a.16.1786994118444;
        Mon, 17 Aug 2026 12:15:18 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:17 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:17 -0400
Subject: [PATCH v4 01/10] ceph: fix error handling when the OSD client is
 stopping in ceph_submit_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-1-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=3647;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=PR2WJRorXsFJP25q+ha589sxpEGLHSUrsTYvs7exL2Q=;
 b=MiiNBNV2/TEXmunVAfFweNzSbK1tOrILyKq6hig9fRhHD4mptc9CP13bSnvq9tUhn4BJarq8m
 zyRitg3Xmy9CS5XcwYpEcwgBOKrL2PtxpNzgf7r1WjjZkGT+5QUzJJL
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX2eoaSQ5fM5VI
 dXS6Wo/c0hnC+llWu5iuU16a6Z3MaDdVGaifexrHwtx8zkyBNPRyZG79T3MIXgYunbJ44i2avb1
 Xf5mgJfmYemu503L2f8vHwwyIqkjhUEOR1sqfqTBinJ6tz0WCaVyDZZ6syhMhBVdvJwCOJcnfUX
 +wSx0ghvYOzt47Ytom4WGKOA7jLfkRG/uV5PwIrdqrdF0dNCdcUl3qKo5P14RmCYZZruNcKfnVH
 OXI8YbYRv4IpC1wJf3OUZG0RT7Fom/+Z8Q4Lww94ZBqppvhqRe31FIsryA3SPokl80Z2HnM4dEe
 Y++yf5w2z8rX17xcf64PIQeUraSw6cehSuTs79cMuoQ5XOBQomIG+4I9dmeMiG9iTuyFR1TYQ6N
 horZ5pLHzhLKbXPBLLhhXu6XkGpdBbunCaslSt+tCa3oy1RImnmjC2DuQ6hT72EUqlgl+d/y3NT
 xR8khc0Dh7p9hv/1BDg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX15jAgZakxqxT
 C6gU2zhN/xg5gQZxLkq4obH7eww3IdJz73xtPRyoLE4/wGvVAcoYPnl4o7CRJiF3kdLa6dZ1rSB
 lnPNxoZrAOcxR0jZb+BswOkWVbOpsWGJKdLmcad5K7JCtdqXv/JN
X-Proofpoint-ORIG-GUID: cvtS44AXSIl2ahc_TDV5nBOLbyIqxkOf
X-Proofpoint-GUID: cvtS44AXSIl2ahc_TDV5nBOLbyIqxkOf
X-Authority-Analysis: v=2.4 cv=HLrz0Itv c=1 sm=1 tr=0 ts=6a835dc7 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=W980AcPXFMIW1GselFUA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170147
X-Rspamd-Queue-Id: 8B8B1140006
X-Stat-Signature: xhxxf7z6ej3suhts85dui9b5gfe7cxmn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786994120-847339
X-HE-Meta: U2FsdGVkX1/ErtqkQfnHcnp3munXNgeiMzg/yTcWfndmtaPbk2Jr2nJ9mMTmd5GWxFsgm2+lijF+wt7HdtxebifxE8TsxdmDskDkcLkTevmxXHXsHR5hCMzNFf/j9RzztKDMsvs3J/ixRxyAhDIt2IncpRj/TqZPMR+RZ6VQe+nqlZY4RtNVEdMwHJff8lfooFOSUR9Vd8mAkWUx2KzdOcN8IZgKpE1pZSNG6I32y22f3PtfrDfUdxjgfRCz0pduD0E1fZYDVtjEJYZN2A1eeRFfbN4ybyBQCRkJj6OwcJ1lTmUS9+62ecF59ZodojKm0YyAWAqU12W9dL43McfqrhVPE45+wDTOOZQQN0EWLCgbHZVBNsccdktdNI9ldfdBjaKhW21sC+fqz9reKyWPvFWDeWl4UpDqnl813mdGMjXcBMp921bZKCKlQlUmGuPyL3V36gt7kGjisHQmI2cZpC3XAoD5BWRZDPuT9m7YkI0cMf5Lso8+MJ3SzxNX6ARd5leR+gMTwli9SNZ9ylB1RDZhCVrNgYFiP/oEm/TnNj+15PWqtabxr/nH0xbiXj3WwJQ1O0CFcjn/vIPJFuaQxcwmmLdpGLk2wiO0HcNXVXzv6IGoczdGdmQahsK0spqLrFaOvaDZkk3Vl877rS2pe9eP29C3u3CahiBZ3xguDDMHbIL3vnJyEa71xdwX78y0wLwA9USRoKtptVq9pPAVXfQwXg2eJXJVifNmPK/K96ux6JZf3KMv4c0/wdK1CATNihNj/sgLQXITIdG96Ev4eDwbDy0rxLfs5EL4JJuxfRZ+r6rcVb20SA0M14uL6sga/jMppS/8S6wKFdq6M4Bapge1htdYnZt8rX8cxDgCrQo62PeQyytEnmJgk1pQ9zezuN7t008OJ1lwCBycv0NjYRXweNwY4M6KTSKnC7tZRj7UXC9eKGWfy0UOd7ea/yPAN8xDXVo6ZSac1u8OSRg
 lstgkZ4W
 feUVP5gVlmbkMpj8J0z9i85fw70nt7roTnF5UUgLALg7WcSiR6QMmZl9UIBX+7G8B4tCGW3NrYzNa6HRqB6+Xyta2tzL3s6b+kz0mxTtQ/bmE71K+xk4XB85OJPhLgx74p9OpCuiCujn7MqNaWUC9ih6PqOIs4qhEtzQo+aUWQLs6giXaw0i0lQkrbq1pkUFBNXF/E+0p3Ct6r+woLvifvkP/woBXVpYPlScKlQLIRyL0Ieb3SqmtQvJRGW6+gjls35dOrVzjL+0hW1W8TiHJL87M27qEJTchM7vOssoBqs5QhFVVkcG6pHS7VYDCKR/vxxqKIbHUSHf0Z7EWhNVRZasb7mngY6in+uw2KtzmZlSSZX5kNvuJya62lV6Y0mgI3069B4NHs5cWVSZIBEtwWosCNAOf7gysavmGFgz69B8C9Ua9yCvvGo3DuG+wgg2v8GJdmr0lE6jIEV141yuvFanGMxdOK91M1GKstUl7O8+cX5yNU3eIPmAMME9fY5q6ZikDMDi9Yg4fF8xOR7iWleDuIo3xNZsseB55u4HF9BARCJlpvGrPonGetJBnRz24RgeUB2c1K5yrg/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When ceph_inc_osd_stopping_blocker() fails, ceph_submit_write()
redirties and unlocks the folios remaining in ceph_wbc->fbatch.
However, none of those folios are locked at this point: locked folios
were moved to ceph_wbc->pages[] and removed from the fbatch by
ceph_process_folio_batch(). Unlocking them triggers
VM_BUG_ON_FOLIO(!folio_test_locked(folio)) in folio_unlock(), or
unlocks a folio locked by another task.

This error path also returns -EIO without fully cleaning up the folios in
ceph_wbc->pages[]: their references are never dropped, fscrypt bounce
pages are never freed, the writeback congestion count is never
decremented, and the pages array is leaked. ceph_wbc->locked_pages is
also left non-zero, so ceph_writepages_start() loops back around and
hits BUG_ON(ceph_wbc.locked_pages).

Leave the fbatch folios alone, as ceph_writepages_start() drops their
references when releasing the batch, and unwind ceph_wbc->pages[] the
same way writepages_finish() would have. Abort writeback in
ceph_writepages_start() instead of continuing, matching the handling
of ceph_inc_osd_stopping_blocker() failure on entry, as the OSD
client is being torn down and further writeback cannot make progress.

An LLM was used to verify that the cleanup was comprehensive, and
suggested aborting the writeback instead of continuing.

Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284%40columbia.edu?part=5
Assisted-by: Claude:fable-5
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 1f77aec8e960..d5a349daf4d0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1482,27 +1482,28 @@ int ceph_submit_write(struct address_space *mapping,
 	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
-		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
-			struct folio *folio = ceph_wbc->fbatch.folios[i];
-
-			if (!folio)
-				continue;
-
-			page = &folio->page;
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-		}
-
 		for (i = 0; i < ceph_wbc->locked_pages; i++) {
-			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
+			fscrypt_finalize_bounce_page(&ceph_wbc->pages[i]);
+			page = ceph_wbc->pages[i];
 
-			if (!page)
-				continue;
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+			    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 
 			ceph_undo_wrbuffer_claim(inode, page_folio(page));
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
+			put_page(page);
+		}
+
+		if (ceph_wbc->from_pool) {
+			mempool_free(ceph_wbc->pages, ceph_wb_pagevec_pool);
+			ceph_wbc->from_pool = false;
+		} else {
+			kfree(ceph_wbc->pages);
 		}
+		ceph_wbc->pages = NULL;
+		ceph_wbc->locked_pages = 0;
 
 		ceph_osdc_put_request(req);
 		return -EIO;
@@ -1736,8 +1737,11 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 		rc = ceph_submit_write(mapping, wbc, &ceph_wbc);
-		if (rc)
-			goto release_folios;
+		if (rc) {
+			/* the OSD client is being torn down, don't retry */
+			folio_batch_release(&ceph_wbc.fbatch);
+			goto dec_osd_stopping_blocker;
+		}
 
 		ceph_wbc.locked_pages = 0;
 		ceph_wbc.strip_unit_end = 0;

-- 
2.39.5


