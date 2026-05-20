Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A110CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DEC6B00CD; Wed, 20 May 2026 18:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DB06B00CE; Wed, 20 May 2026 18:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC886B00CF; Wed, 20 May 2026 18:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B57F6B00CD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:42:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D00931C119D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:42:19 +0000 (UTC)
X-FDA: 84789273198.01.7A31596
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by imf10.hostedemail.com (Postfix) with ESMTP id D9A96C000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:42:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dtR0TjQt;
	spf=pass (imf10.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.60 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779316937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQuc0MZrTT1X5X7PjovAwgE6LeWWPzQwJ2z2JDhDM80=;
	b=8ddJFFf77QXvJ6ZB4LPZcnx95ECVtlFjBQDgiiy9HEAH8hX01XJf8Da9/EF9OY3NBpLPPQ
	y0dUouBmnyIU5wPI9wnPv6MG/YT/E8woYrRELSqM4EPPKCqeGSHMPYlIkkQKxCJFD3WS2b
	qon6QL7J7I25bNFItdQBivrqGHysXhk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dtR0TjQt;
	spf=pass (imf10.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.60 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779316937; a=rsa-sha256;
	cv=fail;
	b=8B7qDMUlGfjPmt9iqw4dHbP9pdASn/gfRmXpMbBA2RU066XDuuqAm7MS9helE92Hq6ILk7
	n3RsIvIcbOc5x9hseZV3Qt8PlExdeY6a4rtbP4whOdna/iaAqrPJMeSU6furVFSXSIwvat
	oxcfQ2BD12dv1zan/fxCaUcyd1ONLMk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAPn39vxzx+jPu7SQWPSFw8b5qcc0BvOzZqPKrjLKNGSuZfxxBozXstIvQclyZreDtJuGcnIC+TzjbeonygWhp8Kq6A29lTCopi3qZ6BenoVHOaHQMJBAmqd5ytY7tiPYZSb101qRMzaxBHSWicc9uvwXFD0pleIlw0Owb+SlHEj5F5BC6SbgRf7KGGQZZYIVwwxcJINVdET27JomWlcjX5eaFcyMvIuIicwSU+UJiHDNPPMo0r1L0SuMqIone8esaB3Qv4O0Mk7KRsXysJvRCMqA965iMrrbDxeVxRW7snxYiKtrz/o5CF1mh5670yjjDAZxtlNtc/n4h8MGjAPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQuc0MZrTT1X5X7PjovAwgE6LeWWPzQwJ2z2JDhDM80=;
 b=egmGESQnDx1jA9wsjnIMyq3E7JFcyqkdemIpfjZFiejGmbsaCZoIZFQaVqGuSTuhj34mHfn7wZ7MaiM1eWuXMw1GWtiKwW9m7pTFnGz7jDebLeBECpWu9Q1HrpjhtC93qXDek87bvOiRxosUUCvh7lMcQEuIpVKAlAw3+Fg4kU4dBsHnzwGKa9PDYFYZ3uvPbVXaMg+RUkLDrbS0lNQwxUxi36Y4UTcAUkwF+cFGJG0UHcYCAICLyWXrKMixCVf22r4nQAkzDBR7oywaSOg/RQlNJFm2nC5hrrzzFdrmvkG7xZH6JQd1sipNSuGRb/b765Za9Y23vwkBDzxdFsMxcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQuc0MZrTT1X5X7PjovAwgE6LeWWPzQwJ2z2JDhDM80=;
 b=dtR0TjQt48L69aV9xHQyerAOBw+QJmqt/ud21ZpEkTXfTkAyRNy2WmNX5fXYM1bjdjP/h1rXyFpcCW92EFkqNMlfWOD2wyc0LGN8k0dOgUZTZHpfJLBuYGkQMWxdX/B4k6mgXhJI6h7bLh4+EesuM6RaGRiV0W2e5l0XdIvRYzjB7+hhRqDq8P6gqhFwJ+TQf9eXsnUJ0+Kq9m88JjdXiBTRLlcxNe1xWUtwF+eWZc67wumtimn6bVCNehm6U22oDwWKdZf2luEAsF0Fdu2JI7BGEoHIN3k+Qp921eV2/PK9Jz6cSFrGp+AAeeTudD4kqEOhZ+TPnl5pl/c9y1VgBA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH2PR12MB4039.namprd12.prod.outlook.com (2603:10b6:610:a8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.16; Wed, 20 May 2026 22:42:10 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 22:42:10 +0000
Date: Thu, 21 May 2026 08:42:05 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com, rppt@kernel.org, 
	tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/4] mm: use arch store helpers in zone-device template
 copies
Message-ID: <ag43be6JFA_feZTi@nvdebian.thelocal>
References: <agpaXHqh1gJE_xcQ@nvdebian.thelocal>
 <20260518064242.57313-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518064242.57313-1-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY6PR01CA0077.ausprd01.prod.outlook.com
 (2603:10c6:10:110::10) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH2PR12MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 57027fac-ae15-44ab-7ad3-08deb6c1075b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|3023799007|5023799004|6133799003|4143699003|11063799006|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Qtl9pIWofpKObc/aO/H35FmGcVIoxPE6pdWYXza83PccTU72H5K8+CH19HwXteaJSR5yWAIkFQdu+GngVpFhQcMPuTcPwzEozzta/wqJdFd6GevO5JBQpk0IKYV1G4quJrstw0JkJg64EmiJpUmeAFpFDcVFX1dA6i5yz1WVpL/FkiuqBfuAAm+PdPiOq4FtbFzCCyQCXNhO5YCZn3+9pr8xLnI4g1L7MuW+pvoD5teWy3e1g+c0B6q3x5615TJ0Fb9anWtdrPHP3NjE0mXchfh0xe5VHtd0QM4oBT0h1ySNpFet3jMh1BBW8fICkOy9LrXItPlt5zC/FvF8ict/QxOJ1/2ojrLP9sOspIkJSAfjZpjHrKBJhBOtubH50jELuVUxX8U63YoMXBISOYQupLGJBW3CII8E8MWgmJDJUotcHQy5pRcEY6/dSBZfSn+NYLYqNbRECPRV7xzVln9XKIVrp5t8c4nD5azd4cEXwn7dpYmdBWXf2+nH5LkkbZBd9cGie1zFeG+lgzCc44NncVZfV23js5/vPlZoI1YpLI4W15/qYYdL+wb2THHZZ0HphFr9tktFqi5geO/GJ75AfZ1g9JK8rQPyCygA36gGiQ5oodHSAp9vOQ17JX+abyvHbU5ZTkuYthoXjCTE6bYUV/bEn8vMdYreMPnM7SJQTwY6/2I+Aad7FaOUEWeJq0HO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(3023799007)(5023799004)(6133799003)(4143699003)(11063799006)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4WVUaE8RtM52YptcGhW6W3YhRIIwjD1SHLFEf7d1kVgpX8XDkRWdPVw9rK2M?=
 =?us-ascii?Q?QDktPfj3YeV26PCzSQWSPy0L2Jd/AQMCF1sbAfTC2D39j0SeX/50PV4CJYyv?=
 =?us-ascii?Q?KxYaDXqj5GIsjQibeYwyW1b94vX+29IG3ClmSkuwmkO5XIywC9MrQ4Y+URb4?=
 =?us-ascii?Q?+b3HilsQ1T4/FcDcUWfujzRLGA6TTUjK4Z2Uco+e3wwwnQ368CHAOMgpQeRi?=
 =?us-ascii?Q?4C1GG0VrL73Ewj7sWXN4AxklKIpv8NSs76VjqNb4EYvXZ7r3UWRzeJe1jlGx?=
 =?us-ascii?Q?r5OSFtNCXmoOlD6Z6LhpvYQdq+WDa5Qem1Dv9PsTaJ3ODbmEfasssBHTxmmR?=
 =?us-ascii?Q?W7WagCIVXZ3+kDxxw1JzverKtNrBGU6Aws+bs/+r5rGglGGBDCPJoVnK0HSD?=
 =?us-ascii?Q?IOBOkxSiHBdVxfRbBZLBU5E9BVLNkH0RoEQAcSUKYNUuA68qUiT3jFXvVkEf?=
 =?us-ascii?Q?V4LsQG/3cf0b5ECISpsaaDw/opjpCFQFFxeQ1o1m4GQQyogFavDV/fwbnDmT?=
 =?us-ascii?Q?v19utpY7RMirDgA+WAZS1Ecjy1HwuSTUd3Vh7Bt7rTqDfiT6qst2mSCqu290?=
 =?us-ascii?Q?hBTHMsENhVYenW36VUm87QDc0xmyAigy29dUBEem6oDFSZHrX2IylXZvCl1C?=
 =?us-ascii?Q?fnPEa/Wxuzv0VJhg3WLyvYFqBHwJWoCCnhsPJpmqZFZbDJVkupMgWqzFT5a7?=
 =?us-ascii?Q?cXJqQ5RmE4o4cs1ZkExS7RLuUug6+Z+XTJngh0aOHSbsopWLgYWWlW33WvqT?=
 =?us-ascii?Q?6+69FZxLKFAoCCfGcFh46lAWV1IbLng66WxwvyqMobpjUvQn/Qm8+p7xyxm0?=
 =?us-ascii?Q?lzSkSfq2VwyOhAmn0v1iQq3efEBZl9rdPcm7eQwQmtOGXKZiU3x8B0eQSdXv?=
 =?us-ascii?Q?utXkVIfizHKAmGFcbkgVx17ufr3n5XLYHHnGxXQmkJFhjTt9dEjKGfh4GQTy?=
 =?us-ascii?Q?yxsHJKWiMI+UcyrFZqk+JmTegUnNhFcHFM9MU7BE4Jff80ofkrXJ9CVqZ3oq?=
 =?us-ascii?Q?Wo7h6QbkS/Dh6io+uiGGI27BkkiXOl9PFabUSL8y4hiMdqNashRnJizoHJ6y?=
 =?us-ascii?Q?hsWyUOs5giKwYq2RNQQT9DdLenKj92pw400aOkAoU3Tto8LfDoNYly7+I+2m?=
 =?us-ascii?Q?jukwL8GQ30ydyoq22NQf8FT4FtAPRx3lPs0ToW5cgnk6ZilHNLXsJ027Cwry?=
 =?us-ascii?Q?akMU2VqNWRXMM9PnPRBry/55aLpDD+iHSqlNXrf65lU3zBDzmak70UhPuBl1?=
 =?us-ascii?Q?o2wKof+6dvK9mm6jnxEDRp9dA3wfnIJGBcVZA1vZq/xvQgVs5DefeWDKBJCo?=
 =?us-ascii?Q?X1+D594RKoS2JOZgSQcH4aJKe/+VtVSIbDkiimb26M5NAa8dhfrugFvYhM/g?=
 =?us-ascii?Q?+TloSpMK5l3yb/iZIguHd2B7f3DdgBWcuY9LjVUfiqg2Nq0EzjR7UWl7c5Jc?=
 =?us-ascii?Q?1DTtoVNYiAZeWuxwW62m4RSCwIfy6NCtn1TJ6XprcmZMp8KDdZphiFqdDcWy?=
 =?us-ascii?Q?E7V8xHRMBKwZJIebVOwroL/8Q7tVn3IsFCkvTHxTjtubISFyZrDlRahTeL5T?=
 =?us-ascii?Q?fUBXvpp1jQ54CG86o5tu3Vsye+RP+PQFjro9OnqoOIu6BeTwaTWR8OqyOtzn?=
 =?us-ascii?Q?TYboueQm4JGBg9U+j6zd/VHgGI/6M/GVU0/0doNr2DCxWXXtTGF31HOfEX61?=
 =?us-ascii?Q?8YzD86cCptGHs3jtN1P/Kr0WLSXin39chcMDDgszpWhWH12PCV3u607ecpok?=
 =?us-ascii?Q?A6gIm4ViXA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57027fac-ae15-44ab-7ad3-08deb6c1075b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 22:42:10.5470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HWasCYKjlgLe9qx0XXf5PQN959YFmq90FGX0BBbCmFnupDHN91BbNCqsuO2u+/6JFUMD2VfkSpU8zk7+5lxLkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4039
X-Stat-Signature: j3bagic7unt6b318kiw7ec1y5xtdzuw6
X-Rspamd-Queue-Id: D9A96C000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779316936-479595
X-HE-Meta: U2FsdGVkX19w7ovZwszEXREPcJIdT+kY/15Em2mbm+xEA1Q2udYoV+PnlS0FukY5YOMMTJc1Bwzme4g9hWEXexTHb76pK3Zhg6ByYieQZUUWhvn3A7YaFmSToJ9RrqpVxBiLYAcmTAKCfFqkdnJW3quicruOrJk3hs+QtPi3MOf1GYwD3ghGjQJRqMQ/rRIrgjhXkm1AjQPOZOtkVgOPlCzf+Gp/9Z8AY/j0K+V4E+/54HkAl0GDA5S/GTdEhR8HhswGucGFFX1aP5+MtyCiRVDUcJigRZSXtj0Wt1uDkg8eJouc6YRbhd+fEfdFO9phvPHm3x6V/mSeS67P082N2Cr/H5Rfla9wTc+N2Kj40CN9zxImGqGdKsPBDIUYikg6BdUQ437Oc/NjiE1G3VHOh0g1jvkLE7WQBXzvcQs5fCE0vupH+B5G/1mssP1cF+aUhqcCT6c9ryuXvkcSI/ElAqKvM/m5tIMCElxXdExW06PjSxCHO8P+5HjD+xs+gdskTx2h9ul7WQn3HSyoLBwTBCfH4gxBPW++LuDX55J2iMnv+tkQVq/NWZG0Fq/yuIipZTFQ9ZyTe0wM2RLfuM7sct5Uq5lL+UGby7q+nchaauZi0Eh8YbBCw7pDIZDzcMRsPrv7dN3+QgLUjpzhf1zhTNFqPjTp41JcL3Qn8ManTfFBYfo++NUcU6LzP39p3CpPC73UWBBpfVgsvuyjNxGo9RibapEFxWuQ1Yp1GuIGQ3k1Inx5dM4pQ1d3CgKRmo83pnnp4hMtF2l98yXOx8r2ZeJpMv4kMMu4vwlmU+rku8LmTZ1P1xLEm9ALMwRsClA7Pczki+RC19QJth4dPCV/PdMaKl68Oi9k5VR760gVafEyGZN+9AVxoGsCBzsJiRTIHqGZ1wkQLyU8WbFi4ODxC88GRXqK/Ex7LTh3hfz0PzW2/gOgeO3tEcwg2Rp5xf8GuP3INlsZtvPGNHZn1En
 U5EeuIGs
 5gJBAgkEcNXSaFp8PCy9qhco5ZaTSnLTLyprun3NBWI+3cD+ux2Np0UMm1aIEFbNhpeztvgWbKROCoZ2aOdQhx1eod1d6t2LU4wOt4mYNh05ETJfBqD/DEej8kqKvECQqhs7cmfNpqL20wr9QKxGhhuJiOK1ydgZd9VsPXK59wrPvtBushNcvuvOiJpx08e1brZgRbyyt7wZd9ibhzvK9sJi7dJmFTVygD41eqQEhsqo3tAR9cixCOwf5R97IEcq5uAlTWak8QCBcOyyWwVh5os5hpwj0jsluKQMsJQLB80VXkRmqpWL99C8087bZohPamms9UjWXQE4vsUE9ymygA8w8JkTFSyxBD+8pxKL1DgrDf7dqrmznW3E1PwMJo/sfFdEYu6Nlc5j+oNuAwl6+MD2F6jQumvssLF2Tp/H2S178UlDPP3OYKJOmEHUUGjKP4QZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-18 at 16:42 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> On Mon, 18 May 2026 10:32:03 +1000, apopple@nvidia.com wrote:
> 
> > On 2026-05-15 at 18:20 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> > > The template-based fast path still leaves the actual copy sequence up to
> > > the compiler. On x86-64 that can easily degrade back into a runtime copy
> > > loop in the hot path, which leaves performance on the table.
> > >
> > > Introduce arch_optimize_store_u64() and arch_optimize_store_drain(),
> > > with a generic fallback and an x86-64 MOVNTI/SFENCE implementation, and
> > > use them in the template copy path. Also open-code the word-at-a-time
> > > copy so the compiler emits fixed-offset stores for the hot path instead
> > > of a runtime loop.
> > >
> > > On x86-64, MOVNTI is a better fit for this write-once, streaming
> > > initialization pattern than normal cached stores. It reduces the
> > > write-allocate traffic and cache pollution that a regular store sequence
> > > would otherwise generate while filling large ranges of struct page.
> > 
> > The perf improvement looks good so thanks for looking at this, however open
> > coding this and introducing arch-specific code layout into a generic layer is
> > not the right approach. The correct solution would be to implement a memcpy
> > implementation/variant that is optimised for write-once streaming operations
> > that can transparently degrade to memcpy on unoptimised architectures.
> > 
> > A grep of the kernel sources for movnti shows there is a memcpy_flushcache()
> > variant. Maybe that could work here?
> 
> Thank you for pointing this out. Using memcpy_flushcache is indeed a
> more generic approach. I will implement the fix in the v2 revision.
> 
> I found that memcpy_flushcache() is implemented on multiple architectures,
> although not all of them can achieve performance benefits during
> ZONE_DEVICE memmap initialization from it. For example, the arm64
> implementation of memcpy_flushcache() simply uses memcpy in conjunction
> with dcache_clean_pop. Therefore, I believe it would be a reasonable choice
> on x86 to introduce a new memcpy variant that invokes memcpy_flushcache().
> 
> > > Refresh the PFN-dependent section bits and page->virtual state in the
> > > reusable template before each copy, instead of patching the destination
> > > page afterwards. This keeps the hot path as a fixed-offset store
> > > sequence and avoids post-copy normal stores to cachelines that were
> > > just written with non-temporal stores.
> > >
> > > Because non-temporal stores are not ordered against later normal stores,
> > > drain outstanding stores before memmap_init_compound() updates compound
> > > heads and before memmap_init_zone_device() returns.
> > >
> > > Disable the x86-64 override under KASAN or KMSAN so those builds keep
> > > their instrumented stores through the generic fallback.
> > >
> > > Tested in a VM with a 100 GB fsdax namespace device configured with
> > > map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> > > server.
> > >
> > > Test procedure:
> > > Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
> > > initialization time from the pr_debug() output of
> > > memmap_init_zone_device().
> > >
> > > Base(v7.1-rc3):
> > >   First binding for nd_pmem driver: 1486 ms
> > >   Average of subsequent rebinds: 273.52 ms
> > >
> > >   First binding for dax_pmem driver: 1515 ms
> > >   Average of subsequent rebinds: 313.45 ms
> > >
> > > With this patch:
> > >   First binding for nd_pmem driver: 1272 ms
> > >   Average of subsequent rebinds: 104.59 ms
> > >
> > >   First binding for dax_pmem driver: 1286 ms
> > >   Average of subsequent rebinds: 116.93 ms
> > >
> > 
> > > This reduces the average rebind time by about 61.8% for nd_pmem and
> > > 62.7% for dax_pmem.
> > 
> > Nice - is this the improvment from applying the whole patch series or just this
> > change?
> 
> These performance improvements are attributable to the entire patch series.
> Maybe It would be clearer to use "With this series" instead of the above
> "With this patch".

Thanks for the clarification. I was asking mostly just to get a feel for how
important this specific patch is to the overall improvement to see if the
complexity was justified. That said using memcpy_flushcache() simplifies things
a lot from the perspective of the memmap code so it's less of an issue, so long
as it's use shows some benefit.

 - Alistair

> > 
> > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > ---
> > >  arch/x86/include/asm/struct_page_init.h | 28 ++++++++
> > >  include/asm-generic/Kbuild              |  1 +
> > >  include/asm-generic/struct_page_init.h  | 17 +++++
> > >  mm/mm_init.c                            | 89 +++++++++++++++++++++----
> > >  4 files changed, 122 insertions(+), 13 deletions(-)
> > >  create mode 100644 arch/x86/include/asm/struct_page_init.h
> > >  create mode 100644 include/asm-generic/struct_page_init.h
> > >
> > > diff --git a/arch/x86/include/asm/struct_page_init.h b/arch/x86/include/asm/struct_page_init.h
> > > new file mode 100644
> > > index 000000000000..de8b4eab44de
> > > --- /dev/null
> > > +++ b/arch/x86/include/asm/struct_page_init.h
> > > @@ -0,0 +1,28 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +#ifndef _ASM_X86_STRUCT_PAGE_INIT_H
> > > +#define _ASM_X86_STRUCT_PAGE_INIT_H
> > > +
> > > +#include <linux/compiler.h>
> > > +#include <linux/types.h>
> > > +
> > > +/*
> > > + * x86-64 guarantees SSE2, so MOVNTI and SFENCE are always available there.
> > > + *
> > > + * KASAN/KMSAN rely on compiler-instrumented stores. Keep the x86 override
> > > + * disabled for those configs and fall back to plain stores instead.
> > > + */
> > > +#if defined(CONFIG_X86_64) && !defined(CONFIG_KASAN) && !defined(CONFIG_KMSAN)
> > > +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> > > +{
> > > +	asm volatile("movnti %1, %0" : "=m"(*dst) : "r"(val));
> > > +}
> > > +
> > > +static __always_inline void arch_optimize_store_drain(void)
> > > +{
> > > +	asm volatile("sfence" : : : "memory");
> > > +}
> > > +#else
> > > +#include <asm-generic/struct_page_init.h>
> > > +#endif
> > > +
> > > +#endif /* _ASM_X86_STRUCT_PAGE_INIT_H */
> > > diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> > > index 2c53a1e0b760..3a493fed6803 100644
> > > --- a/include/asm-generic/Kbuild
> > > +++ b/include/asm-generic/Kbuild
> > > @@ -65,3 +65,4 @@ mandatory-y += vermagic.h
> > >  mandatory-y += vga.h
> > >  mandatory-y += video.h
> > >  mandatory-y += word-at-a-time.h
> > > +mandatory-y += struct_page_init.h
> > > diff --git a/include/asm-generic/struct_page_init.h b/include/asm-generic/struct_page_init.h
> > > new file mode 100644
> > > index 000000000000..45a722103a51
> > > --- /dev/null
> > > +++ b/include/asm-generic/struct_page_init.h
> > > @@ -0,0 +1,17 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +#ifndef _ASM_GENERIC_STRUCT_PAGE_INIT_H
> > > +#define _ASM_GENERIC_STRUCT_PAGE_INIT_H
> > > +
> > > +#include <linux/compiler.h>
> > > +#include <linux/types.h>
> > > +
> > > +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> > > +{
> > > +	*dst = val;
> > > +}
> > > +
> > > +static __always_inline void arch_optimize_store_drain(void)
> > > +{
> > > +}
> > > +
> > > +#endif /* _ASM_GENERIC_STRUCT_PAGE_INIT_H */
> > > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > > index 5a9e6ecfa894..a3211666ccd4 100644
> > > --- a/mm/mm_init.c
> > > +++ b/mm/mm_init.c
> > > @@ -37,6 +37,7 @@
> > >  #include "shuffle.h"
> > >
> > >  #include <asm/setup.h>
> > > +#include <asm/struct_page_init.h>
> > >
> > >  #ifndef CONFIG_NUMA
> > >  unsigned long max_mapnr;
> > > @@ -1078,9 +1079,21 @@ static inline bool zone_device_page_init_optimization_enabled(void)
> > >  	return !page_ref_tracepoint_active(page_ref_set);
> > >  }
> > >
> > > +/*
> > > + * The fast path copies struct page with fixed-offset u64 stores instead of
> > > + * a runtime loop. Keep that copy sequence in sync with the struct page
> > > + * layouts supported by this build.
> > > + *
> > > + * The sequence below requires struct page to be u64-aligned and currently
> > > + * handles layouts from 7 to 12 u64 words (56 to 96 bytes). If a future
> > > + * layout falls outside that range, fail the build so the store sequence is
> > > + * updated together with the layout change.
> > > + */
> > >  static inline void struct_page_layout_check(void)
> > >  {
> > >  	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
> > > +	BUILD_BUG_ON(sizeof(struct page) < 56);
> > > +	BUILD_BUG_ON(sizeof(struct page) > 96);
> > 
> > This would be uneccessary without the open-coded memcpy and is another reason to
> > prefer a more generic approach.
> 
> Yes, I will fix this issue in v2.
> 
> > >  }
> > >
> > >  static inline void init_template_head_page(struct page *template,
> > > @@ -1108,30 +1121,67 @@ static inline void init_template_tail_page(struct page *template,
> > >  }
> > >
> > >  /*
> > > - * Initialize parts that differ from the template
> > > + * 'template' is a reusable page prototype rather than a strictly immutable
> > > + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> > > + * the current template, but section bits and page->virtual may still depend
> > > + * on the PFN. Refresh those PFN-dependent fields in the template before
> > > + * copying it into @page.
> > >   */
> > > -static inline void generic_init_zone_device_page_finish(struct page *page,
> > > -							unsigned long pfn)
> > > +static inline void zone_device_page_update_template(struct page *template,
> > > +						    unsigned long pfn)
> > >  {
> > >  #ifdef SECTION_IN_PAGE_FLAGS
> > > -	set_page_section(page, pfn_to_section_nr(pfn));
> > > +	set_page_section(template, pfn_to_section_nr(pfn));
> > >  #endif
> > >  #ifdef WANT_PAGE_VIRTUAL
> > >  	if (!is_highmem_idx(ZONE_DEVICE))
> > > -		set_page_address(page, __va(pfn << PAGE_SHIFT));
> > > +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> > >  #endif
> > >  }
> > >
> > >  static void init_zone_device_page_from_template(struct page *page,
> > > -		unsigned long pfn, const struct page *template)
> > > +		unsigned long pfn, struct page *template)
> > >  {
> > >  	const u64 *src = (const u64 *)template;
> > >  	u64 *dst = (u64 *)page;
> > > -	unsigned int i;
> > >
> > > -	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> > > -		dst[i] = src[i];
> > > -	generic_init_zone_device_page_finish(page, pfn);
> > > +	/*
> > > +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> > > +	 * page. Update the PFN-dependent fields in place before copying it
> > > +	 * to the destination page.
> > > +	 */
> > > +	zone_device_page_update_template(template, pfn);
> > > +
> > > +	/*
> > > +	 * Keep the copy open-coded so the compiler emits fixed-offset stores
> > > +	 * for the hot path instead of a runtime copy loop.
> > > +	 */
> > > +	switch (sizeof(struct page)) {
> > > +	case 96:
> > > +		arch_optimize_store_u64(&dst[11], src[11]);
> > > +		fallthrough;
> > > +	case 88:
> > > +		arch_optimize_store_u64(&dst[10], src[10]);
> > > +		fallthrough;
> > > +	case 80:
> > > +		arch_optimize_store_u64(&dst[9], src[9]);
> > > +		fallthrough;
> > > +	case 72:
> > > +		arch_optimize_store_u64(&dst[8], src[8]);
> > > +		fallthrough;
> > > +	case 64:
> > > +		arch_optimize_store_u64(&dst[7], src[7]);
> > > +		fallthrough;
> > > +	case 56:
> > > +		arch_optimize_store_u64(&dst[6], src[6]);
> > > +		arch_optimize_store_u64(&dst[5], src[5]);
> > > +		arch_optimize_store_u64(&dst[4], src[4]);
> > > +		arch_optimize_store_u64(&dst[3], src[3]);
> > > +		arch_optimize_store_u64(&dst[2], src[2]);
> > > +		arch_optimize_store_u64(&dst[1], src[1]);
> > > +		arch_optimize_store_u64(&dst[0], src[0]);
> > > +	}
> > > +
> > 
> > I don't think unrolling the copy here is the right approach. This belongs in
> > some kind of generic streaming memcpy routine.
> 
> Yes. I've taken a look at the memcpy_flushcache() implementation on x86,
> and it only unrolls for sizes of 4, 8, and 16 bytes; all other sizes fall
> back to the generic loop. I think we need to extend the x86 implementation
> of memcpy_flushcache() so that its fast path covers at least
> sizeof(struct page).
> 
> Thanks,
> Zhe

